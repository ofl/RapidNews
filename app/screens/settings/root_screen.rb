class Settings::RootScreen < PM::GroupedTableScreen

  title "Settings"

  def on_load
    @view_is_set_up ||= set_up_view
  end

  def set_up_view
    set_nav_bar_button :left, system_item: :close, action: :on_close_button_tapped

    true
  end

  def table_data
    @settings_table_data = [
      {
        cells: [
          {
            title: "Article Size",
            subtitle: RN::Titles::ARTICLES_SIZE[App::Persistence['articles_size']],
            action: :on_cell_tapped,
            arguments: { menu: :articles_size },
            accessoryType: UITableViewCellAccessoryDisclosureIndicator,
            cell_style: UITableViewCellStyleValue1,
          },
          {
            title: "Appearece",
            subtitle: RN::Titles::APPEARENCE[App::Persistence['appearence']],
            action: :on_cell_tapped,
            arguments: { menu: :appearence },
            accessoryType: UITableViewCellAccessoryDisclosureIndicator,
            cell_style: UITableViewCellStyleValue1,
          }
        ]
      },{
        title: 'Share',
        cells: [
          {
            title: "Services",
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
            subtitle: RN::Titles::SWIPE_LEFT[App::Persistence['swipe_left']],
            action: :on_cell_tapped,
            arguments: { menu: "swipe_left" },
            accessoryType: UITableViewCellAccessoryDisclosureIndicator,
            cell_style: UITableViewCellStyleValue1,
          },
          {
            title: "Swipe Right",
            subtitle: RN::Titles::SWIPE_RIGHT[App::Persistence['swipe_right']],
            action: :on_cell_tapped,
            arguments: { menu: "swipe_right" },
            accessoryType: UITableViewCellAccessoryDisclosureIndicator,
            cell_style: UITableViewCellStyleValue1,
          }
        ]
      },{
        title: 'About',
        cells: [
          {
            title: "Credit",
            action: :on_credit_cell_tapped,
            accessoryType: UITableViewCellAccessoryDisclosureIndicator,
          },
          {
            title: "Web Site",
            action: :on_web_site_cell_tapped,
            arguments: { menu: "web" },
            accessoryType: UITableViewCellAccessoryNone
          },
          {
            title: "Email",
            action: :on_email_cell_tapped,
            arguments: { menu: "email" },
            accessoryType: UITableViewCellAccessoryNone,
          },
        ]
      }
    ]
  end

  def on_cell_tapped(args = {})
    property = args[:menu]
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

  def on_credit_cell_tapped
    open Settings::CreditScreen.new(nav_bar: true)
  end

  def on_web_site_cell_tapped
    UIApplication.sharedApplication.openURL(NSURL.URLWithString("https://github.com/ofl/RapidNews"))
  end

  def on_email_cell_tapped
    unless MFMailComposeViewController.canSendMail
      App.alert("It is necessary to set the send mail")
      return
    end
    c = MFMailComposeViewController.alloc.init
    c.setToRecipients(['admin@covered.jp'])
    c.mailComposeDelegate = self
    self.presentModalViewController(c, animated:true)
  end

  def on_close_button_tapped
    close(refresh: true)
  end

  def on_return(args = {})
    if args[:model_saved]
      update_table_data
    end
  end

  def mailComposeController(controller, didFinishWithResult: result, error: error)
    if error
      App.alert("[Error]Can not send mail.")
    end
    controller.dismissModalViewControllerAnimated(true)
  end
end
