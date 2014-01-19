class Channels::EditScreen < PM::GroupedTableScreen
  stylesheet :channels_edit_screen

  attr_accessor :channel

  def on_load
    @is_saved = false
    self.title = @channel.name
  end

  def settiing
    @text_field = create_text_field
    [
      {
        cells: [
          {
            title: BW::localized_string(:title, 'Title'),
            selectionStyle: UITableViewCellSelectionStyleNone,
            value: @channel.name,
            accessory: {
              view: @text_field
            }
          }, {
            title: BW::localized_string(:enabled, 'Enabled'),
            selectionStyle: UITableViewCellSelectionStyleNone,
            accessory: {
              view: :switch,
              value: @channel.is_checked,
              action: :on_switch_changed,
              arguments: {}
            }
          }
        ]
      }
    ]
  end

  def create_text_field
    text_field = UITextField.alloc.initWithFrame(CGRectMake(100, 10, 200, 22)).tap do |tf|
      tf.delegate = self
      tf.text = @channel.name
      tf.autocorrectionType = UITextAutocorrectionTypeNo
      tf.autocapitalizationType = UITextAutocapitalizationTypeNone
      tf.textAlignment = UITextAlignmentRight
      tf.returnKeyType = UIReturnKeyDone
      tf.placeholder = BW::localized_string(:channel_name, 'Channel Name')
      tf.textColor = RN::Const::Color::EDITABLE
    end
  end

  def table_data
    @data ||= settiing
  end

  def textFieldShouldReturn(text_field)
    @text_field.resignFirstResponder
    true    
  end

  def on_switch_changed(args={})
    @channel.is_checked = args[:value]
    @channel.save
    Channel.save_to_file

    @is_saved = true
  end

  def will_dismiss
    unless @channel.name == @text_field.text
      @channel.name = @text_field.text
      @channel.save
      Channel.save_to_file
      @is_saved = true
    end
    self.parent_screen.on_return(model_saved: @is_saved)
  end
end
