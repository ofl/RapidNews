class Channels::NewsSourceSelectImagePathScreen < PM::GroupedTableScreen
  attr_accessor :news_source

  def on_load
    @current_choice = @news_source.image_path
    self.title = BW::localized_string(:image_path, "Image Path")
  end

  def will_present
    @is_changed = false
  end

  def table_data
    constants = []
    NewsSource.all.each do |news_source|
      unless constants.include?(news_source.image_path)
        constants.push news_source.image_path
      end
    end
    len = constants.length
    [{ cells: (0...len).map{ |index| create_cell(constants[index]) } }]
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
      title: choice,
      action: :on_cell_tapped,
      accessoryType: ac,
      arguments: choice,
    }
  end

  def on_cell_tapped(choice)
    @current_choice = choice
    @news_source.image_path = choice
    @is_changed = true
    update_table_data
  end

  def will_dismiss
    self.parent_screen.on_return(model_changed: @is_changed)
  end
end
