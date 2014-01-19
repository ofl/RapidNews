class Channels::NewsSourceFeedsScreen < PM::TableScreen
  attr_accessor :news_source

  refreshable callback: :on_refresh,
    pull_message: BW::localized_string(:pull_to_refresh, "Pull to refresh"),
    refreshing: BW::localized_string(:refreshing, "Refreshing data...")

  stylesheet :news_source_feeds_screen

  def on_load
    self.title = @news_source.name
    @feed_hash = {}
    fetch_feed
  end

  def on_refresh
    fetch_feed
  end

  def table_data
    @items ||= []
  end

  def fetch_feed
    req = NSURLRequest.alloc.initWithURL(NSURL.URLWithString(@news_source.url))
    AFXMLRequestOperation.addAcceptableContentTypes(NSSet.setWithObject("application/rss+xml"))

    op = AFXMLRequestOperation.alloc.initWithRequest(req)
    op.setCompletionBlockWithSuccess(method(:success_crawl).to_proc, 
                                     failure: method(:failure_crawl).to_proc)
    op.start
  end

  def success_crawl(operation, responseObject)
    err = Pointer.new(:object)
    @feed_hash = XMLReader.dictionaryForXMLString(operation.responseString, error: err)
    if @feed_hash.is_a?(Hash)
      Dispatch::Queue.main.async{ parse_rss }
    else
      @feed_hash = {}
    end
  end

  def failure_crawl(operation, error)
    NSLog(error.localizedDescription)
  end

  def parse_rss
    entries_path = @feed_hash.valueForKeyPath('rss.channel.atom') ? 'rss.channel.atom' : 'rss.channel.item' 
    cells = []
    @feed_hash.valueForKeyPath(entries_path).each do |item|
      next  if item['rel'] == 'self' # for atom info item
      article = Article.build(@news_source, item)
      cells.push create_cell(article, item)
    end
    @items = [{cells: cells}]
    end_refreshing
    update_table_data
  end

  def create_cell(article, item)
    {
      cell_identifier: "Cell",
      cell_style: UITableViewCellStyleSubtitle,
      height: 44,
      title: article.title,
      subtitle: article.summary,
      action: :tapped_item,
      arguments: item,
      remote_image: {
        url: article.image_url,
        placeholder: 'images/77x50.png',
      },
    }
  end

  def tapped_item(item)
    # p item.dup
    # p flatten(item.dup)
    # stringify_keys(item.dup)
    # open WebScreen.new(url: item.link, title: item.title)
  end
end
