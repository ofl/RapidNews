class Settings::PreferenceScreen < PM::GroupedTableScreen
  attr_accessor :property, :constant, :constant_names

  def on_load
    self.title = BW::localized_string(@property.to_sym, @property)
  end

  def will_present
    @is_saved = false
  end

  def table_data
    @current_choice = App::Persistence[@property]
    len = RN::Const.const_get(@constant).constants(true).length
    [{ cells: (0...len).map{ |choice| create_cell(choice) } }]
  end

  def create_cell(choice)
    if choice == @current_choice
      ac = UITableViewCellAccessoryCheckmark
    else UITableViewCellAccessoryNone
      ac = UITableViewCellAccessoryNone
    end
    {
      cell_identifier: "Cell",
      cell_style: UITableViewCellStyleDefault,
      selectionStyle: UITableViewCellSelectionStyleNone,
      title: @constant_names[choice],
      action: :on_cell_tapped,
      accessoryType: ac,
      arguments: choice,
    }
  end

  def on_cell_tapped(choice)
    App::Persistence[@property] = choice
    @is_saved = true
    update_table_data
  end

  def will_dismiss
    self.parent_screen.on_return(model_saved: @is_saved)
  end
end
