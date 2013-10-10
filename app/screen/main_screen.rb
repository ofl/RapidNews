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
      @nav_bar = subview MainNavigationBar.new, delegate: self
      @tool_bar = subview MainToolBar.new, delegate: self
    end

    @article_manager.load_data
    true
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
                                 @tool_bar.backgroundColor = BW.rgba_color(150, 150, 150, 0.30)
                               },
                               completion: nil)
    true
  end

  def hide_controller
    nf = CGRectMake(0, -66, App.frame.size.width, @nav_bar.frame.size.height)
    tf = CGRectMake(0, self.view.bounds.size.height - 44,
                    App.frame.size.width, @tool_bar.frame.size.height)
    UIView.animateWithDuration(0.40,
                               delay: 0.0,
                               options: UIViewAnimationOptionCurveEaseOut,
                               animations: -> {
                                 @nav_bar.frame = nf
                                 @tool_bar.frame = tf
                                 @tool_bar.backgroundColor = BW.rgba_color(60, 60, 60, 0)
                               },
                               completion: -> (finished) {true})
    false
  end

  def add_observers
    BW::App.notification_center.observe Channels::RootScreen::CrawlNewsSource do |n|
      n.userInfo[:ids].each do |id|
        source = NewsSource.find(id)
        source.crawl_articles if source
      end
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
  end


  def stop_reading
    @article_manager.is_reading = false if @article_manager.is_reading
  end

  def open_preview_screen
    open_modal Preview::RootScreen.new(
      nav_bar: true,
      article: @article_manager.displaying,
      modalTransitionStyle: UIModalTransitionStyleCrossDissolve
    )
  end

  def add_to_bookmark
    App.alert("No article is selected.") unless @article_manager.add_to_bookmarks
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

  def on_toolbar_add_button_tapped
    add_to_bookmark
  end

  def on_toolbar_preview_button_tapped
    open_preview_screen
  end

  def on_toolbar_action_button_tapped
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

  def on_navbar_settings_button_tapped
    open_modal Settings::RootScreen.new(nav_bar: true)
  end

  def on_navbar_channels_button_tapped
    open_modal Channels::RootScreen.new(nav_bar: true)
  end

  def on_navbar_bookmarks_button_tapped
    open_modal Bookmarks::RootScreen.new(nav_bar: true)
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
