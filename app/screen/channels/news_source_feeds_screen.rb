class Channels::NewsSourceFeedsScreen < PM::TableScreen
  attr_accessor :news_source

  refreshable callback: :on_refresh,
    pull_message: "Pull to refresh",
    refreshing: "Refreshing data..."

  stylesheet :news_source_feeds_screen

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
    dict = XMLReader.dictionaryForXMLString(operation.responseString, error: err)
    return unless dict.is_a?(Hash)

    Dispatch::Queue.concurrent.async do
      parse_rss(dict)
    end
  end

  def failure_crawl(operation, error)
    NSLog(error.localizedDescription)
  end

  def parse_rss(dict)
    entries_path = dict.valueForKeyPath('rss.xmlns:atom') ? 'rss.channel.atom' : 'rss.channel.item' 
    cells = []
    dict.valueForKeyPath(entries_path).each do |item|
      article = Article.build(@news_source, item)
      cells.push create_cell(article)
    end
    @items = [{cells: cells}]
    end_refreshing
    update_table_data
  end

  def create_cell(item)
    {
      cell_identifier: "Cell",
      cell_style: UITableViewCellStyleSubtitle,
      height: 60,
      title: item.title,
      subtitle: item.summary,
      action: :tapped_item,
      arguments: item,
      remote_image: {
        # url: item.content["url"],
        url: item.image_url,
        placeholder: '77x50.png',
        height: 50,
        width: 77,
      },
    }
  end


  def will_appear
    self.title = @news_source.name
    fetch_feed
  end

  def on_refresh
    fetch_feed
  end

  def table_data
    @items ||= []
  end

  def tapped_item(item)
    open WebScreen.new(url: item.link, title: item.title)
  end
end
