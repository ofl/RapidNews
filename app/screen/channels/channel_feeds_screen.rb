class Channels::ChannelFeedsScreen < PM::TableScreen
  attr_accessor :link_url
  title "BlankNews"
  refreshable callback: :on_refresh,
    pull_message: "Pull to refresh",
    refreshing: "Refreshing data..."

  stylesheet :channel_feeds_screen

  def fetch_feed
    BW::HTTP.get(@link_url) do |res|
      items = []
      if res.ok?
        BW::RSSParser.new(res.body.to_str, true).parse do |item|
          items.push(item)
        end
      else
        App.alert(res.error_message)
      end

      @items = [{cells: items.map{ |item| create_cell item }}]
      end_refreshing
      update_table_data
    end
  end

  def create_cell(item)
    # p item
    titleLabel = UILabel.new.tap do |l|
      l.stylename = :titleLabel
      l.text = item.title
    end
    {
      cell_identifier: "Cell",
      cell_style: UITableViewCellStyleSubtitle,
      height: 60,
      # title: item.title,
      # subtitle: item.pubDate,
      action: :tapped_item,
      arguments: item,
      # remote_image: {
      #   # url: item.content["url"],
      #   url: item.content[:url],
      #   placeholder: '77x50.png',
      #   height: 50,
      #   width: 77,
      # },
      subviews: [titleLabel]
    }
  end

  def will_appear
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
