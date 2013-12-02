# -*- coding: utf-8 -*-

class ArticleManager
  
  include BW::KVO
  attr_accessor :index, :is_reading, :count, :ids, :crawling_url_list_count, 
                :interval, :bookmarks_count, :can_load_image

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
      @crawling_url_list = {}
      @crawling_url_list_count = 0
      @is_reading = false
      @interval = App::Persistence[:interval]
      @can_load_image = true

      update_bookmarks_count
      add_observers
    end
  end

  # status

  def current_article
    find_article_by_index(@index)    
  end

  def can_go_forward
    @index < @ids.length - 1
  end

  def can_go_back
    @index > 0
  end

  def set_online_status(online_status)
    if online_status == FXReachabilityStatusNotReachable
      @can_load_image = false
    elsif !@is_reading
      @can_load_image = true
    elsif online_status == FXReachabilityStatusReachableViaWiFi && @interval > 1.0
      @can_load_image = true
    elsif online_status == FXReachabilityStatusReachableViaWWAN && @interval > 2.0
      @can_load_image = true
    else
      @can_load_image = false
    end
  end

  def label_text
    if @ids.length > 0
      "#{@index + 1}/#{@ids.length}"
    else
      "0/0"
    end
  end

  def is_over_max_article_size
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
    return if is_over_max_article_size
    update_max_articles_size
    add_to_crawling_url_list(source)
    NSLog("Request: #{source.url}")

    req = NSURLRequest.alloc.initWithURL(NSURL.URLWithString(source.url))
    AFXMLRequestOperation.addAcceptableContentTypes(NSSet.setWithObject("application/rss+xml"))

    op = AFXMLRequestOperation.alloc.initWithRequest(req)
    op.setCompletionBlockWithSuccess(method(:on_success_crawl).to_proc, 
                                     failure: method(:on_failure_crawl).to_proc)
    op.start
  end

  def on_success_crawl(operation, responseObject)
    err = Pointer.new(:object)
    dict = XMLReader.dictionaryForXMLString(operation.responseString, error: err)
    return unless dict.is_a?(Hash)

    Dispatch::Queue.concurrent.async do
      parse_rss(dict, @crawling_url_list[operation.request.URL.absoluteString])
      cut_over
      remove_from_crawling_url_list(operation.request.URL.absoluteString)
    end
  end

  def on_failure_crawl(operation, error)
    remove_from_crawling_url_list(operation.request.URL.absoluteString)
    NSLog(error.localizedDescription)
  end

  def parse_rss(dict, source)
    entries_path = @feed_hash.valueForKeyPath('rss.channel.atom') ? 'rss.channel.atom' : 'rss.channel.item' 
    dict.valueForKeyPath(entries_path).each do |item|
      break if is_over_max_article_size
      next  if item['rel'] == 'self' # for atom info item
      next if Article.where(:link_url).eq(item[:link][:text].dup).count > 0

      article = Article.build(source, item)
      if article
        article.save
        @ids.push(article.id) 
      end
    end
    Article.save_to_file
  end

  def add_to_crawling_url_list(source)
    @crawling_url_list[source.url] = source
    @crawling_url_list_count = @crawling_url_list.count
  end

  def add_to_bookmarks
    if self.current_article
      self.current_article.is_bookmarked = true
      self.current_article.save
      update_bookmarks_count
      Article.save_to_file
      return true
    else
      return false
    end
  end

  def update_bookmarks_count
    self.bookmarks_count = Article.where(:is_bookmarked).eq(true).count    
  end

  def remove_from_crawling_url_list(url)
    @crawling_url_list.delete(url)
    self.crawling_url_list_count = @crawling_url_list.count
  end

  def find_article_by_index(idx)
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
