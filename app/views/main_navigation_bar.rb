class MainNavigationBar < UINavigationBar

  include BW::KVO

  BUTTONS = [:settings_button, :channels_button, :bookmarks_button, :hide_menu_button]

  def initWithFrame(frame)
    super.tap do
      @article_manager = ArticleManager.instance

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

      btn_view = UIView.alloc.initWithFrame(CGRectMake(0,0,42,30))
      btn_view.backgroundColor = BW.rgba_color(30, 30, 30, 0.80)

      image = UIImage.imageNamed('images/bookmark.png')
      tinted_image = image.tintedImageWithColor(BW.rgb_color(0,255,255))

      book_button = UIButton.buttonWithType(UIButtonTypeCustom).tap do |b|
        b.setFrame(CGRectMake(0, 0, 40, 30))
        b.setImage(tinted_image, forState: UIControlStateNormal)
        b.addTarget(self, action: "on_bookmarks_button_tapped", forControlEvents: UIControlEventTouchUpInside)
      end

      btn_view.addSubview book_button
      bookmarks_button = UIBarButtonItem.alloc.initWithCustomView(btn_view)

      @badge = UILabel.new
      @badge.stylename = :badge
      @badge.layer.cornerRadius = 8
      refresh_badge
      btn_view.addSubview @badge

      hide_menu_button = UIBarButtonItem.alloc.initWithImage(UIImage.imageNamed('images/expand.png'),
                                                   style: UIBarButtonItemStylePlain,
                                                   target: self,
                                                   action: "on_hide_menu_button_tapped")

      navigation_item.leftBarButtonItems = [settings_button, spacer, channels_button, spacer, bookmarks_button, spacer, hide_menu_button]
      self.pushNavigationItem(navigation_item, animated:false)

      observe(@article_manager, "bookmarks_count") do |old_value, new_value|
        Dispatch::Queue.main.async { refresh_badge }
      end
    end
  end

  def refresh_badge
    @badge.text = @article_manager.bookmarks_count.to_s
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
