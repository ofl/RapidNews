class Settings::SharesScreen < PM::GroupedTableScreen
  title BW::localized_string(:share_services, "Share Services")

  def on_load
    @view_is_set_up ||= set_up_view
  end

  def set_up_view
    @services = []
    RN::Titles::SHARE_SERVICE.each do |k, v|
      @services.push({name: v, id: k})
    end
    @services.sort! { |a, b| a[:id] <=> b[:id] }
    true
  end

  def table_data
    [
      {
        cells: @services.map{ |service|create_cell(service) }
      }
    ]
  end

  def create_cell(service)
    {
      cell_identifier: "Cell",
      cell_style: UITableViewCellStyleDefault,
      selectionStyle: UITableViewCellSelectionStyleNone,
      title: service[:name],
      action: :on_cell_tapped,
      accessoryType: UITableViewCellAccessoryDisclosureIndicator,
      arguments: {id: service[:id]},
    }
  end

  def on_cell_tapped(args = {})
    case args[:id]
    when RN::Const::ShareService::HATENA
      open Settings::SharesHTBScreen.new(nav_bar: true, service: args[:id])    
    when RN::Const::ShareService::POCKET
      open Settings::SharesPocketScreen.new(nav_bar: true, service: args[:id])    
    end
  end

  def on_return(args = {})
    if args[:model_saved]
      update_table_data
    end
  end

  def will_dismiss
    self.parent_screen.on_return(model_saved: true)
  end
end
