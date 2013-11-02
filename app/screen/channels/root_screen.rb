# class EditChannelsScreen < PM::GroupedTableScreen
class Channels::RootScreen < PM::TableScreen
  def self.get_indexable
  end

  def on_load
    @editing = false    
    set_nav_bar_button :left, system_item: :close, action: :on_close_button_tapped
  end

  def will_present
  end

  def will_appear
    self.title = 'Edit Channels'
    self.navigationItem.rightBarButtonItem = self.editButtonItem
    # set_nav_bar_button :right, system_item: :edit, action: :add_channel
    self.table_view.allowsSelectionDuringEditing = true
  end

  def table_data
    @channels = Channel.order(:position).all
    [{ cells: @channels.map{ |channel| create_cell channel } }]
  end

  def create_cell(channel)
    {
      cell_identifier: "Cell",
      cell_style: UITableViewCellStyleDefault,
      title: channel.name,
      action: :on_cell_tapped,
      text_color: channel.is_checked ? BW.rgb_color(0, 0, 0) : BW.rgb_color(200, 200, 200),
      # accessoryType: channel.is_checked ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone,
      accessoryType: UITableViewCellAccessoryDisclosureIndicator,
      arguments: {id: channel.id}
    }
  end

  def tableView(table_view, canMoveRowAtIndexPath: index_path)
    return true
  end

  def tableView(table_view, moveRowAtIndexPath: f, toIndexPath: t)
    @channels[f.row].move_position_to(f.row, t.row)
    update_table_data
  end

  def tableView(table_view,  shouldIndentWhileEditingRowAtIndexPath: index_path)
    false
  end

  def tableView(table_view, targetIndexPathForMoveFromRowAtIndexPath: s, toProposedIndexPath: p)
    if p.row == @channels.count
      return s
    else
      return p
    end
  end

  def on_close_button_tapped
    close()
  end

  def on_cell_tapped(args)
    if @editing
      open Channels::EditScreen.new(nav_bar: true, id: args[:id])
    else
      open Channels::ChannelScreen.new(nav_bar: true, channel_id: args[:id])
    end
  end

  def on_cell_deleted(cell)
    news_source = NewsSource.find(cell[:arguments][:id])
    @channel.unregist(news_source)
    true
  end

  def on_return(args = {})
    if args[:model_saved]
      update_table_data
    end
  end

  def setEditing(editing, animated: animated)
    super
    self.table_view.setEditing(editing, animated:true)
    if editing
      @editing = true
      addButton = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'add_row')
      self.navigationItem.setLeftBarButtonItem(addButton, animated:true) 
    else 
      @editing = false
      set_nav_bar_button :left, system_item: :close, action: :on_close_button_tapped
    end
  end

  def will_dismiss
  end
end
