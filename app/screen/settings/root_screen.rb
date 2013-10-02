class Settings::RootScreen < PM::GroupedTableScreen

  title "Settings"

  def self.get_indexable; end # bug?

  def will_appear
    @view_is_set_up ||= set_up_view
  end

  def set_up_view
    set_nav_bar_button :left, system_item: :close, action: :on_close_button_tapped
    self.navigation_controller.navigationBar.barTintColor = UIColor.whiteColor

    true
  end

  def table_data
    @settings_table_data = [
      {
        cells: [
          {
            title: "Article Size",
            indentationLevel: 2,
            subtitle: RN::Titles::ARTICLES_SIZE[App::Persistence['articles_size']],
            action: :on_cell_tapped,
            arguments: { menu: :articles_size },
            accessoryType: UITableViewCellAccessoryDisclosureIndicator,
            cell_style: UITableViewCellStyleValue1,
          },
        ]
      },{
        title: 'Speed',
        cells: [
          {
            title: "Speed",
            indentationLevel: 2,
            subtitle: RN::Titles::SPEED[App::Persistence['speed']],
            action: :on_cell_tapped,
            arguments: { menu: :speed },
            accessoryType: UITableViewCellAccessoryDisclosureIndicator,
            cell_style: UITableViewCellStyleValue1,
          },
          {
            title: "Accelerate",
            indentationLevel: 2,
            subtitle: RN::Titles::ACCELERATE[App::Persistence['accelerate']],
            action: :on_cell_tapped,
            arguments: { menu: :accelerate },
            accessoryType: UITableViewCellAccessoryDisclosureIndicator,
            cell_style: UITableViewCellStyleValue1,
          }
        ]
      },{
        title: 'Appearence',
        cells: [
          {
            title: "Font Size",
            indentationLevel: 2,
            subtitle: RN::Titles::FONT_SIZE[App::Persistence['font_size']],
            action: :on_cell_tapped,
            arguments: { menu: :font_size },
            accessoryType: UITableViewCellAccessoryDisclosureIndicator,
            cell_style: UITableViewCellStyleValue1,
          },
          {
            title: "Design",
            indentationLevel: 2,
            subtitle: RN::Titles::DESIGN[App::Persistence['design']],
            action: :on_cell_tapped,
            arguments: { menu: :design },
            accessoryType: UITableViewCellAccessoryDisclosureIndicator,
            cell_style: UITableViewCellStyleValue1,
          }
        ]
      },{
        title: 'Share',
        cells: [
          {
            title: "Services",
            indentationLevel: 2,
            action: :on_share_cell_tapped,
            arguments: { menu: :share },
            accessoryType: UITableViewCellAccessoryDisclosureIndicator,
            cell_style: UITableViewCellStyleValue1,
          }
        ]
      },{
        title: 'Gesture',
        cells: [
          {
            title: "Swipe Left",
            indentationLevel: 2,
            subtitle: RN::Titles::SWIPE_ACTION[App::Persistence['swipe_left']],
            action: :on_cell_tapped,
            arguments: { menu: "swipe_left" },
            accessoryType: UITableViewCellAccessoryDisclosureIndicator,
            subviews: [icon_label('arrow-left')],
            cell_style: UITableViewCellStyleValue1,
          },
          {
            title: "Swipe Right",
            indentationLevel: 2,
            subtitle: RN::Titles::SWIPE_ACTION[App::Persistence['swipe_right']],
            action: :on_cell_tapped,
            arguments: { menu: "swipe_right" },
            accessoryType: UITableViewCellAccessoryDisclosureIndicator,
            subviews: [icon_label('arrow-right')],
            cell_style: UITableViewCellStyleValue1,
          }
        ]
      },{
        title: 'Contact',
        cells: [
          {
            title: "Web Site",
            indentationLevel: 2,
            action: :on_cell_tapped,
            arguments: { menu: "web" },
            subviews: [icon_label('globe')],
            accessoryType: UITableViewCellAccessoryNone
          },
          {
            title: "Email",
            indentationLevel: 2,
            action: :on_cell_tapped,
            arguments: { menu: "email" },
            subviews: [icon_label('envelope-alt')],
            accessoryType: UITableViewCellAccessoryNone,
          },
        ]
      }
    ]
  end

  def icon_label(icon)
    UILabel.new.tap do |l|
      l.frame = [[10, 13], [20, 20]]
      l.backgroundColor = UIColor.clearColor
      l.text = FontAwesome.icon(icon)
      l.textColor = rgb_color(0,0,0)
      l.font = FontAwesome.fontWithSize(17.0)
    end
  end

  def on_cell_tapped(args = {})
    if ['swipe_left', 'swipe_right'].include?(args[:menu])
      property = "swipe_action"
    else
      property = args[:menu]
    end
    open Settings::PreferenceScreen.new(
      nav_bar: true,
      property: property,
      constant: property.to_s.camelize,
      constant_names: RN::Titles.const_get(property.to_s.upcase)
    )
  end

  def on_share_cell_tapped
    open Settings::SharesScreen.new(nav_bar: true)
  end

  def on_close_button_tapped
    close()
  end

  def on_return(args = {})
    if args[:model_saved]
      update_table_data
    end
  end
end
