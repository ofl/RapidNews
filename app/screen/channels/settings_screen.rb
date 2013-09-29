class Channels::SettingsScreen < PM::GroupedTableScreen
  title "Settings"

  stylesheet :settings

  def self.get_indexable
  end

  # def on_load
  # end

  def will_appear
    @view_is_set_up ||= set_up_view
  end

  def set_up_view
    true
  end

  def set_up_table_view
    @channels = Channel.order(:position).all
    super
  end

  def table_data
    @settings_table_data = [
      {
        cells: [
          { 
            title: "Sources", 
            action: :on_cell_tapped, 
            arguments: { menu: :source },
            accessoryType: UITableViewCellAccessoryDisclosureIndicator
          },
          { 
            title: "Channels", 
            action: :on_cell_tapped, 
            arguments: { menu: :channel },
            accessoryType: UITableViewCellAccessoryDisclosureIndicator
          }
        ]
      },{
        title: 'Refresh Button Channel',
        cells: @channels.map{ |channel| create_cell(channel) }
      }
    ]
  end

  def create_cell(channel)
    if App::Persistence['default_channel_id'] == channel.id
      accessoryType = UITableViewCellAccessoryCheckmark
    else
      accessoryType = UITableViewCellAccessoryNone
    end
    {
      cell_identifier: "Cell",
      cell_style: UITableViewCellStyleDefault,
      selectionStyle: UITableViewCellSelectionStyleNone,
      title: channel.name,
      action: :set_default_channel,
      accessoryType: accessoryType,
      arguments: {id: channel.id},
    }
  end

  def on_cell_tapped(args = {})
    if args[:menu] == :source
      open Channels::CountriesScreen.new(nav_bar: true)
    elsif args[:menu] == :channel
      open ChannelsSettingsChannelsScreen.new(nav_bar: true)
    end      
  end

  def set_default_channel(channel)
    App::Persistence['default_channel_id'] = channel[:id]
    update_table_data
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
