class Channels::ChannelScreen < PM::TableScreen

  attr_accessor :channel_id

  def self.get_indexable
  end

  def on_load
    @editing = false    
  end

  def will_present
  end

  def will_appear
    self.title = @channel.name
    addButton = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'add_source')
    self.navigationItem.rightBarButtonItem = addButton
  end

  def set_up_table_view
    @channel = Channel.find(@channel_id)
    super
  end

  def table_data
    [{
        cells: @channel.news_sources.map{ |news_source| create_cell news_source }
    }]
  end

  def create_cell(news_source)
    {
      cell_identifier: "Cell",
      cell_style: UITableViewCellStyleDefault,
      title: news_source.name,
      action: :on_cell_tapped,
      accessoryType: UITableViewCellAccessoryDisclosureIndicator,
      arguments: {id: news_source.id, link_url: news_source.url}
    }
  end

  def add_source
    open Channels::ChannelSourcesScreen.new(nav_bar: true, channel_id: @channel.id) 
  end

  def tableView(table_view, canMoveRowAtIndexPath:index_path)
    return true
  end

  def tableView(table_view,  shouldIndentWhileEditingRowAtIndexPath: index_path)
    false
  end

  def on_cell_tapped(args={})
    open Channels::ChannelFeedsScreen.new({nav_bar: true, link_url: args[:link_url]})
  end

  def on_return(args = {})
    if args[:model_saved]
      update_table_data
    end
  end

  def will_dismiss
  end
end