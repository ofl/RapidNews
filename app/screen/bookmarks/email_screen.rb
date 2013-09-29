class Bookmarks::EmailScreen < Bookmarks::ReaderScreen

  def will_appear
    @is_saved = false
    self.title = 'Email'
  end

  def create_text_field(field_num, field_name)
    data = App::Persistence[RN::Titles::EMAIL_FIELD[field_num]]
    text = data.instance_of?(Array) ? data.join(',') : data

    text_field = UITextField.alloc.initWithFrame(CGRectMake(100, 10, 200, 22)).tap do |tf|
      tf.delegate = self
      tf.text = text
      tf.autocorrectionType = UITextAutocorrectionTypeNo
      tf.autocapitalizationType = UITextAutocapitalizationTypeNone
      tf.textAlignment = UITextAlignmentRight
      tf.returnKeyType = UIReturnKeyDone
      tf.placeholder = @placeholder_titles[field_name.to_sym]
      tf.tag = field_num
    end
  end

  def set_table_data
    @reader = RN::Const::BookmarkReader::EMAIL
    @fields = RN::Titles::EMAIL_FIELD
    cells = []
    @placeholder_titles = {
      email_subject: 'Hello',
      email_to: 'test@example.com',
      email_cc: 'test@example.com',
      email_bcc: 'test@example.com',
    }

    @fields.each do |k, v|
      cells.push(textFieldCell(k,v))
    end

    [create_button_cell, {title: 'Field', cells: cells}]
  end

  def textFieldCell(k,v)
    {
      title: v,
      selectionStyle: UITableViewCellSelectionStyleNone,
      accessory: { view: create_text_field(k, v) },
    }
  end

  def textFieldShouldReturn(text_field)
    text_field.resignFirstResponder
    true    
  end

  def will_dismiss
    @fields.each do |k, v|
      text_field = self.view.viewWithTag(k)
      if App::Persistence[v].instance_of?(Array)
        App::Persistence[v] = text_field.text.split(',')
      else
        App::Persistence[v] = text_field.text
      end
    end
    self.parent_screen.on_return(model_saved: @is_saved)
  end
end
