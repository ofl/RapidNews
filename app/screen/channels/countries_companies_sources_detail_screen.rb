class Channels::CountriesSourcesDetailScreen < PM::GroupedTableScreen
  attr_accessor :id, :company_name

  def self.get_indexable
  end

  def will_present
    @is_saved = false
  end

  def will_appear
    self.title = @company_name
  end

  def set_up_table_view
    @news_source = NewsSource.find(@id)
    @channels = Channel.order(:position).all
    super
  end

  def table_data
    @channel = @news_source.channel
    [
      {
        cells: [
          {
            title: @news_source.name,
            action: :open_rss_feeds,
            accessoryType: UITableViewCellAccessoryDisclosureIndicator
          }
        ]
      },
      {
        title: 'Channel',
        cells: @channels.map{ |channel| create_cell channel }
      },
    ]
  end

  def create_cell(channel)
    {
      cell_identifier: "Cell",
      cell_style: UITableViewCellStyleDefault,
      selectionStyle: UITableViewCellSelectionStyleNone,
      title: channel.name,
      action: :on_cell_tapped,
      accessoryType: channel == @channel ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone,
      arguments: channel,
    }
  end

  def open_rss_feeds    
    open Channels::CountriesCompaniesSourcesDetailFeedsScreen.new({nav_bar: true, 
                                                                   title: @news_source.name, 
                                                                   link_url: @news_source.url})
  end

  def on_cell_tapped(channel)
    if channel == @channel
      # channel.news_sources.delete(@news_source)
      channel.unregist(@news_source)
    else
      channel.regist(@news_source)
    end
    @is_saved = true
    update_table_data
  end

  def will_dismiss
  end
end
