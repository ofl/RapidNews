# -*- coding: utf-8 -*-

class ArticleManager
  
  include BW::KVO
  attr_accessor :index, :is_reading, :count, :ids, :crawling_urls_count

  def self.instance
    Dispatch.once { @instance ||= new }
    @instance
  end

  def initialize
    unless @max_article_size
      update_max_articles_size
      @ns = NSNotificationCenter.defaultCenter
      @ids = []
      @count = 0
      @index = 0
      @cache = {}
      @crawling_urls = {}
      @crawling_urls_count = 0
      @is_reading = false

      add_observers
    end
  end

  # status

  def can_go_forward
    @index < @ids.length - 1
  end

  def can_go_back
    @index > 0
  end

  def label_text
    if @ids.length > 0
      "#{@index + 1}/#{@ids.length}"
    else
      "0/0"
    end
  end

  def is_reach_max_article_size
    @index < 1 && @ids.length > @max_article_size - 1
  end

  def update_max_articles_size
    @max_article_size = RN::Titles::ARTICLES_SIZE[App::Persistence['articles_size']].to_i
  end

  def load_data
    update_max_articles_size
    articles = Article.order(:id).all
    articles.each do |article|
      @ids.push(article.id)
    end
    @index = App::Persistence['index']
    cut_over
  end

  def crawl(source)
    return if is_reach_max_article_size
    update_max_articles_size
    add_to_crawling_urls(source)
    NSLog("Request: #{source.url}")

    req = NSURLRequest.alloc.initWithURL(NSURL.URLWithString(source.url))
    AFXMLRequestOperation.addAcceptableContentTypes(NSSet.setWithObject("application/rss+xml"))

    op = AFXMLRequestOperation.alloc.initWithRequest(req)
    op.setCompletionBlockWithSuccess(method(:success_crawl).to_proc, 
                                     failure: method(:failure_crawl).to_proc)
    op.start
  end

  def success_crawl(operation, responseObject)
    err = Pointer.new(:object)
    dict = XMLReader.dictionaryForXMLString(operation.responseString, error: err)
    return unless dict.is_a?(Hash)

    Dispatch::Queue.concurrent.async do
      parse_rss(dict, @crawling_urls[operation.request.URL.absoluteString])
      cut_over
      remove_from_crawling_urls(operation.request.URL.absoluteString)
    end
  end

  def failure_crawl(operation, error)
    remove_from_crawling_urls(operation.request.URL.absoluteString)
    NSLog(error.localizedDescription)
  end

  def parse_rss(dict, source)
    if dict.valueForKeyPath('rss.xmlns:atom')
      entries_path = 'rss.channel.atom'
    else
      entries_path = 'rss.channel.item'
    end
    dict.valueForKeyPath(entries_path).each do |item|
      break if is_reach_max_article_size
      next if Article.where(:link_url).eq(item[:link][:text]).count > 0
      obj = Article.create_unique_article(source, item)
      @ids.push(obj.id) if obj
    end
    Article.save_to_file
  end

  def add_to_crawling_urls(source)
    @crawling_urls[source.url] = source
    @crawling_urls_count = @crawling_urls.count
  end

  def remove_from_crawling_urls(url)
    @crawling_urls.delete(url)
    self.crawling_urls_count = @crawling_urls.count
  end

  def displaying
    find_by_index(@index)
  end

  def find_by_index(idx)
    d = @cache[@ids[idx]]
    return d if d
    return Article.find(@ids[idx])
  end

  def add_to_cache
    next_id = @ids[@index + 1]
    if next_id
      unless @cache[next_id]
        @cache[next_id] =  Article.find(next_id)
        if @cache[next_id]
          url = NSURL.URLWithString(@cache[next_id].image_url)
          UIImageView.cacheImageWithURL(url)
        end
      end
    end
    next_next_id = @ids[@index + 2]
    if next_next_id
      unless @cache[next_next_id]
        @cache[next_next_id] =  Article.find(next_next_id)
        if @cache[next_id]
          url = NSURL.URLWithString(@cache[next_id].image_url)
          UIImageView.cacheImageWithURL(url)
        end
      end
    end
  end

  def remove_from_cache
    @cache.each do |k, v|
      if k > @ids[@index] + 2 || k < @ids[@index] - 2
        @cache.delete(k)
      end
    end
  end

  def cut_over
    index = @index < @ids.length ? @index : 0

    over = @ids.length - @max_article_size
    if over > 0
      @ids.shift(over)
      index = index - over > 0 ? index - over : 0
    end

    @index = index
    self.count = @ids.length
  end

  def sweep
    over = Article.count - Article.bookmarks.count - @max_article_size

    if over > 0
      articles = Article.where(:is_bookmarked).eq(false).order(:id).all()
      over.times do |index|
        unless @ids.include?(articles[index].id)
          articles[index].delete
        end
      end
    end
    Article.save_to_file
  end

  def add_observers
    observe(self, "index") do |old_value, new_value|
      App::Persistence['index'] = new_value
      remove_from_cache
      add_to_cache
    end

    observe(self, "is_reading") do |old_value, new_value|
      self.sweep unless new_value
    end
  end
end
