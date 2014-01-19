class Channels::NewsSourceSelectScreen < PM::GroupedTableScreen
  attr_accessor :news_source, :property, :constant, :constant_names

  def on_load
    @current_choice = @news_source.send(@property)   
    @is_changed = false
    self.title = BW::localized_string(@property.to_sym, @property)
  end

  def will_present
    @is_changed = false
  end

  def table_data
    constants = RN::Const.const_get(@constant).constants(true)
    len = constants.length
    [{ cells: (0...len).map{ |choice| create_cell(RN::Const.const_get(@constant).const_get(constants[choice])) } }]
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
    @current_choice = choice
    @news_source.send(@property + '=', choice)
    @is_changed = true
    update_table_data
  end

  def will_dismiss
    self.parent_screen.on_return(model_changed: @is_changed)
  end
end
