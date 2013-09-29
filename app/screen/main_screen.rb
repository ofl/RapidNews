# -*- coding: utf-8 -*-

class MainScreen < PM::Screen

  include BW::KVO
  stylesheet :main_screen

  def on_load
    @channel = nil
    @article_manager = ArticleManager.instance
    add_observers
  end

  def will_appear
    @view_setup ||= set_up_view
  end

  def actionSheet(actionSheet, clickedButtonAtIndex: buttonIndex)
    case buttonIndex
    when 0
      if refresh_default_channel
        SVProgressHUD.showWithStatus("Loading...")
      end
    end
  end

  def set_up_view
    layout(self.view, :base_view) do # from rubymotion/TeaCup
      self.navigation_controller.navigationBarHidden = true
      @slide_view = subview MainSlideView.new, {frame: self.view.bounds, delegate: self}

      @bookmarked_button = button(:bookmarked_button).tap do |b|
        b.when(UIControlEventTouchUpInside) { on_bookmarked_button_tapped }
      end

      button(:preview_button).tap do |b|
        b.when(UIControlEventTouchUpInside) { on_preview_button_tapped }
        b.setTitleColor(BW.rgb_color(255, 255, 255), forState: UIControlStateHighlighted)
        b.setTitleColor(BW.rgb_color(40, 40, 40), forState: UIControlStateDisabled)
      end
      @counter_label = subview VerticallyAlignedLabel.new, :counter_label

      @nav_bar = subview MainNavigationBar.new, delegate: self
      @tool_bar = subview MainToolBar.new, delegate: self
    end

    @article_manager.load_data
    true
  end

  def refresh_view
    @counter_label.text = @article_manager.label_text
    update_bookmarked_button_color
  end

  def update_bookmarked_button_color
    article = @article_manager.displaying
    if article && article.is_bookmarked
      @bookmarked_button.stylename = :is_bookmarked
    else
      @bookmarked_button.stylename = :is_not_bookmarked
    end
  end

  #Show/Hide Menu

  def show_controller
    stop_reading
    nf = CGRectMake(0, 0, App.frame.size.width, @nav_bar.frame.size.height)
    tf = CGRectMake(0, self.view.bounds.size.height - @tool_bar.frame.size.height,
                    App.frame.size.width, @tool_bar.frame.size.height)
    UIView.animateWithDuration(0.40,
                               delay: 0.0,
                               options: UIViewAnimationOptionCurveEaseOut,
                               animations: -> {
                                 @nav_bar.frame = nf
                                 @tool_bar.frame = tf
                               },
                               completion: nil)
    true
  end

  def hide_controller
    nf = CGRectMake(0, -66, App.frame.size.width, @nav_bar.frame.size.height)
    tf = CGRectMake(0, self.view.bounds.size.height,
                    App.frame.size.width, @tool_bar.frame.size.height)
    UIView.animateWithDuration(0.40,
                               delay: 0.0,
                               options: UIViewAnimationOptionCurveEaseOut,
                               animations: -> {
                                 @nav_bar.frame = nf
                                 @tool_bar.frame = tf
                               },
                               completion: -> (finished) {true})
    false
  end

  def add_observers
    BW::App.notification_center.observe ChannelsScreen::CrawlNewsSource do |n|
      n.userInfo[:ids].each do |id|
        source = NewsSource.find(id)
        source.crawl_articles if source
      end
    end

    observe(@article_manager, "count") do |old_value, new_value|
      Dispatch::Queue.main.async{
        @counter_label.text = @article_manager.label_text
      }
    end

    observe(@article_manager, "crawling_urls_count") do |old_value, new_value|
      if old_value > new_value && new_value == 0
        Dispatch::Queue.main.async{
          new_article_size = @article_manager.count - @article_manager.index - 1
          if new_article_size > 0
            SVProgressHUD.showSuccessWithStatus("#{new_article_size} new articles.")
          else
            SVProgressHUD.showErrorWithStatus("No new articles found.")
          end
        }
      end
    end

    observe(@article_manager, "index") do |old_value, new_value|
      refresh_view
    end
  end


  def stop_reading
    @article_manager.is_reading = false if @article_manager.is_reading
  end

  def open_preview_screen
    open_modal PreviewScreen.new(
      nav_bar: true,
      article: @article_manager.displaying,
      modalTransitionStyle: UIModalTransitionStyleCrossDissolve
    )
  end

  def add_to_bookmark
    article = @article_manager.displaying
    if article
      article.is_bookmarked = !article.is_bookmarked
      article.save
      update_bookmarked_button_color
    else
      App.alert("No article is selected.")
    end
  end

  def open_activity
    article = @article_manager.displaying
    if article
      text = article.title + " (#{article.company.host_name})"
      url = NSURL.URLWithString(article.link_url)

      activityView = URLActivityViewController.alloc.initWithDefaultActivities([text, url])
      self.presentViewController(activityView, animated:true, completion:nil)
    else
      App.alert("No article is selected.")
    end
  end

  def refresh_default_channel
    @channel = Channel.find(App::Persistence['default_channel_id'])
    @channel ||= Channel.where(:is_checked).eq(true).order(:position).first
    if @channel
      ids = @channel.news_sources.all.map(&:id)
      if ids.length > 0
        ids.each do |id|
          source = NewsSource.find(id)
          source.crawl_articles if source
        end
        true
      else
        App.alert("No source is selected.")
        false
      end
    else
      App.alert("No channel is selected.")
      false
    end
  end

  #Event handler

  def confirm_load_article
    action_sheet = UIActionSheet.alloc.init.tap do |as|
      as.delegate = self
      as.title = 'Load Default Channel?'
      as.addButtonWithTitle('Load')
      as.addButtonWithTitle('Cancel')
      as.cancelButtonIndex = 1
    end
    action_sheet.showInView(self.view)
  end

  def on_bookmarked_button_tapped
    add_to_bookmark
  end

  def on_preview_button_tapped
    open_preview_screen
  end

  def on_navbar_settings_button_tapped
    open_modal SettingsScreen.new(nav_bar: true)
  end

  def on_navbar_channels_button_tapped
    open_modal ChannelsScreen.new(nav_bar: true)
  end

  def on_navbar_bookmarks_button_tapped
    open_modal BookmarksScreen.new(nav_bar: true)
  end

  def on_navbar_hide_menu_button_tapped
    hide_controller
  end

  def on_return(args = {})
    if @article_manager.crawling_urls_count > 0
      SVProgressHUD.showWithStatus("Loading...")
    end
    # if args[:model_saved]
    # end
  end
end
