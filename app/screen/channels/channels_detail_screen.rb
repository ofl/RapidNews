class Channels::ChannelsDetailScreen < PM::GroupedTableScreen
  stylesheet :channels_settings_channel_detail_screen

  attr_accessor :id

  def self.get_indexable
  end

  def will_appear
    @is_saved = false
    self.title = @channel.name
  end

  def settiing
    @text_field = UITextField.new
    @text_field.delegate = self    
    set_attributes @text_field, {stylename: :text_field}
    @text_field.text = @channel.name
    [
      {
        cells: [
          {
            title: "Title",
            selectionStyle: UITableViewCellSelectionStyleNone,
            value: @channel.name,
            accessory: {
              view: @text_field,
              arguments: {}
            }
          }, {
            title: "Enabled",
            selectionStyle: UITableViewCellSelectionStyleNone,
            accessory: {
              view: :switch,
              value: @channel.is_checked,
              action: :on_switch_changed,
              arguments: {}
            }
          }
        ]
      },
      {
        title: 'Sources',
        cells: [
          {
            title: "Sources",
            action: :on_cell_tapped,
            accessoryType: UITableViewCellAccessoryDisclosureIndicator
          }
        ]
      }
    ]
  end

  def table_data
    @channel = Channel.find(@id)
    @data ||= settiing
  end

  def textFieldShouldReturn(text_field)
    @text_field.resignFirstResponder
    true    
  end

  def on_switch_changed(args={})
    @channel.is_checked = args[:value]
    @channel.save
    Channel.load_from_file

    @is_saved = true
  end

  def on_cell_tapped
    open Channels::ChannelsDetailSourcesScreen.new(nav_bar: true, 
                                                   channel_id: @channel.id)
  end

  def will_dismiss
    unless @channel.name == @text_field.text
      @channel.name = @text_field.text
      @channel.save
      Channel.load_from_file
      @is_saved = true
    end
    self.parent_screen.on_return(model_saved: @is_saved)
  end
end
