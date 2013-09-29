class Channels::ChannelsDetailSourcesScreen < PM::TableScreen

  attr_accessor :channel_id

  def self.get_indexable
  end

  def will_present
  end

  def will_appear
    self.title = @channel.name
    self.navigationItem.rightBarButtonItem = self.editButtonItem
  end

  def set_up_table_view
    @channel = Channel.find(@channel_id)
    super
  end

  def table_data
    @news_sources = @channel.news_sources.order(:position).all
    [{
        cells: @news_sources.map{ |news_source| create_cell news_source }
    }]
  end

  def create_cell(news_source)
    {
      cell_identifier: "Cell",
      cell_style: UITableViewCellStyleDefault,
      title: news_source.name,
      action: :on_cell_tapped,
      accessoryType: UITableViewCellAccessoryDisclosureIndicator,
      arguments: {id: news_source.id},
      editing_style: :delete,
    }
  end

  def tableView(table_view, canMoveRowAtIndexPath:index_path)
    return true
  end

  def tableView(table_view, moveRowAtIndexPath: f, toIndexPath: t)
    @news_sources[f.row].move_position_to(f.row, t.row)
    update_table_data
  end

  def tableView(table_view,  shouldIndentWhileEditingRowAtIndexPath: index_path)
    false
  end

  def tableView(table_view, targetIndexPathForMoveFromRowAtIndexPath:s, toProposedIndexPath: t)
    if t.row == @news_sources.count
      return s 
    else
      return t
    end
  end

  def on_cell_deleted(cell)
    news_source = NewsSource.find(cell[:arguments][:id])
    @channel.unregist(news_source)
    true
  end

  def on_cell_tapped(args)
    open Channels::CountriesSourcesDetailScreen.new(nav_bar: true, id: args[:id])
  end

  def will_dismiss
  end
end