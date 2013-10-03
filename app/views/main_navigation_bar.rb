class MainNavigationBar < UINavigationBar

  BUTTONS = [:settings_button, :channels_button, :bookmarks_button, :hide_menu_button]

  def initWithFrame(frame)
    super.tap do
      self.stylesheet = :main_navigation_bar
      self.stylename = :base_view
      self.barStyle = UIBarStyleBlack

      navigation_item = UINavigationItem.new

      spacer = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace,
                                                               target: nil,
                                                               action: nil)

      settings_button = UIBarButtonItem.alloc.initWithImage(UIImage.imageNamed('images/settings.png'),
                                                   style: UIBarButtonItemStylePlain,
                                                   target: self,
                                                   action: "on_settings_button_tapped")

      channels_button = UIBarButtonItem.alloc.initWithImage(UIImage.imageNamed('images/retro_tv.png'),
                                                   style: UIBarButtonItemStylePlain,
                                                   target: self,
                                                   action: "on_channels_button_tapped")

      bookmarks_button = UIBarButtonItem.alloc.initWithImage(UIImage.imageNamed('images/bookmark.png'),
                                                   style: UIBarButtonItemStylePlain,
                                                   target: self,
                                                   action: "on_bookmarks_button_tapped")

      hide_menu_button = UIBarButtonItem.alloc.initWithImage(UIImage.imageNamed('images/expand.png'),
                                                   style: UIBarButtonItemStylePlain,
                                                   target: self,
                                                   action: "on_hide_menu_button_tapped")

      navigation_item.leftBarButtonItems = [settings_button, spacer, channels_button, spacer, bookmarks_button, spacer, hide_menu_button]
      self.pushNavigationItem(navigation_item, animated:false)
    end
  end

  def on_settings_button_tapped
    self.delegate.on_navbar_settings_button_tapped
  end

  def on_channels_button_tapped
    self.delegate.on_navbar_channels_button_tapped
  end

  def on_bookmarks_button_tapped
    self.delegate.on_navbar_bookmarks_button_tapped
  end

  def on_hide_menu_button_tapped
    self.delegate.on_navbar_hide_menu_button_tapped
  end
end
