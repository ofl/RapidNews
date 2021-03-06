class Bookmarks::ReaderScreen < PM::GroupedTableScreen

  def table_data
    @data = set_table_data
  end

  def set_table_data
  end

  def create_button_cell
    @switch_settings = [
      'bookmark_readers', 'bookmark_desolve_after', 'bookmark_all_send'
    ]
    titles = {
      bookmark_readers: BW::localized_string(:show_button, "Show Button"), 
      bookmark_desolve_after: BW::localized_string(:desolve_after, "Desolve all after send."), 
      bookmark_all_send: BW::localized_string(:send_all, "Always send all")
    }
    cells = @switch_settings.map do |name|
      {
        title: titles[name.to_sym],
        selectionStyle: UITableViewCellSelectionStyleNone,
        accessory: {
          view: :switch,
          value: App::Persistence[name].include?(@reader),
          action: :on_switch_changed,
          arguments: {name: name}
        }
      }
    end
    {cells: cells}
  end

  def on_switch_changed(args={})
    array = App::Persistence[args[:name]].dup
    if args[:value] && !array.include?(@reader)
      array.push(@reader)
      App::Persistence[args[:name]] = array
    elsif !args[:value] && array.include?(@reader)
      array.delete(@reader)
    end
    App::Persistence[args[:name]] = array
    @is_saved = true
  end

  def will_dismiss
  end
end
