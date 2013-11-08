class Channels::NewsSourceSelectScreen < PM::GroupedTableScreen
  attr_accessor :id, :property, :constant, :constant_names

  def self.get_indexable
  end

  def will_present
    @is_saved = false
  end

  def will_appear
    self.title = @property
  end

  def table_data
    @news_source = NewsSource.find(@id)
    @current_choice = @news_source.send(@property)
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
    @news_source.send(@property + '=', choice)
    @news_source.save
    NewsSource.save_to_file
    @is_saved = true
    update_table_data
  end

  def will_dismiss
    self.parent_screen.on_return(model_saved: @is_saved)
  end
end
