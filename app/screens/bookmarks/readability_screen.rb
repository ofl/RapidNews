class Bookmarks::ReadabilityScreen < Bookmarks::ReaderScreen

  def on_load
    @is_saved = false
    self.title = 'Readability'
  end

  def set_table_data
    @reader = RN::Const::BookmarkReader::READABILITY
    @text_field = UITextField.new
    @text_field.delegate = self    
    # set_attributes @text_field, {stylename: :text_field}
    @text_field.text = ''

    [
      create_button_cell,
      {
        title: 'Field',
        cells: [
          {
            title: "ID",
            selectionStyle: UITableViewCellSelectionStyleNone,
            value: '',
            accessory: {
              view: @text_field,
              arguments: {}
            }
          },{
            title: "Password",
            selectionStyle: UITableViewCellSelectionStyleNone,
            value: '',
            accessory: {
              view: @text_field,
              arguments: {}
            }
          }
        ]
      }
    ]
  end

  def textFieldShouldReturn(text_field)
    @text_field.resignFirstResponder
    true    
  end
end
