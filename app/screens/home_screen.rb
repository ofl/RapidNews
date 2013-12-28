# -*- coding: utf-8 -*-

class HomeScreen < PM::Screen

  include BW::KVO
  stylesheet :home_screen

  THRESHOLD = 1.0

  def on_load
    @channel = nil
    @article_manager = ArticleManager.instance
    @interval = 3.0
    @timer = nil
    @speed_control_timer = nil
    add_observers
  end

  def will_appear
    @view_setup ||= set_up_view
  end

  def set_up_view
    layout(self.view, :base_view) do # from rubymotion/TeaCup
      self.navigation_controller.navigationBarHidden = true
      @slide_view = subview HomeSlideView.new, {frame: self.view.bounds, delegate: self}
      @nav_bar = subview HomeNavigationBar.new, delegate: self
      @tool_bar = subview HomeToolBar.new, delegate: self
    end

    @article_manager.load_data
    true
  end


  #reading

  def set_article_at_index(index)
    return if @article_manager.count == 0

    if @interval > THRESHOLD
      @slide_view.set_article_at_index(@article_manager.index)
    else
      @slide_view.update_article_at_index(@article_manager.index)
    end
  end

  def show_next_article
    if @article_manager.index < @article_manager.count - 1
      adjust_interval
      if @interval > THRESHOLD
        @slide_view.slide_up
      else
        @slide_view.pop_view_except_current
        @article_manager.index = @article_manager.index + 1
      end
      set_timer
    else
      @article_manager.is_reading = false
    end
  end

  def adjust_interval
    if @interval > @article_manager.interval
      @interval = [@interval * 0.7, @article_manager.interval].max
    else
      @interval = @article_manager.interval
    end
  end

  def stop_timer
    if @timer
      @timer.invalidate
      @timer = nil
    end
  end

  def set_timer
    stop_timer
    @timer = NSTimer.scheduledTimerWithTimeInterval(@interval, 
                                                    target: self, 
                                                    selector: 'show_next_article', 
                                                    userInfo: nil, 
                                                    repeats: false)    
  end

  def start_playing
    set_timer
  end

  def stop_playing
    if @timer
      stop_timer

      if @interval <= THRESHOLD
        @interval = [@article_manager.interval, 2.0].max
        @slide_view.set_article_at_index(@article_manager.index)
      end
    end
    @interval = @article_manager.interval > 2.0 ? @article_manager.interval : 2.0
  end

  def stop_reading
    @article_manager.is_reading = false if @article_manager.is_reading
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

  def open_preview_screen
    open_modal Preview::RootScreen.new(
      nav_bar: true,
      is_modal: true,
      article: @article_manager.current_article,
      modalTransitionStyle: UIModalTransitionStyleCrossDissolve
    )
  end

  def open_channel_modal_view
    channels_modal_view = ChannelsModalView.new
    channels_modal_view.delegate = self
    self.navigation_controller.presentSemiView(channels_modal_view, withOptions:{})    
  end

  def add_to_bookmark
    App.alert("No article is selected.") unless @article_manager.add_to_bookmarks
  end

  def load_channel_articles(channel_id)
    @channel = Channel.find(channel_id)
    ids = @channel.news_sources.map(&:id)
    if ids.count > 0
      ids.each do |id|
        source = NewsSource.find(id)
        source.crawl_articles if source
      end
      SVProgressHUD.showWithStatus("Loading...", maskType: SVProgressHUDMaskTypeBlack)
    else
      App.alert("No source is selected.")
    end    
  end

  def dismiss_channel_view
    self.navigation_controller.dismissSemiModalView
  end

  def hide_speed_status
    SVProgressHUD.dismiss
    @speed_control_timer = nil
  end


  #Event handler

  def add_observers
    BW::App.notification_center.observe FXReachabilityStatusDidChangeNotification do |n|
      @article_manager.set_online_status FXReachability.sharedInstance.status
    end

    observe(@article_manager, "crawling_url_list_count") do |old_value, new_value|
      if old_value > new_value && new_value == 0
        Dispatch::Queue.main.async{
          new_article_size = @article_manager.count - @article_manager.index - 1
          if new_article_size > 0
            SVProgressHUD.showSuccessWithStatus("#{new_article_size} new articles.")
          else
            SVProgressHUD.showErrorWithStatus("No new articles found.")
          end
        }
        @channel.update_image_url
      end
    end

    observe(@article_manager, "count") do |old_value, new_value|
      Dispatch::Queue.main.async{
        if @article_manager.count > 0
          @slide_view.set_article_at_index(@article_manager.index)
        end
      }
    end

    observe(@article_manager, "index") do |old_value, new_value|
      Dispatch::Queue.main.async{
        if @article_manager.count > 0 && @article_manager.index < @article_manager.count
          @slide_view.set_article_at_index(@article_manager.index)
        end
      }
    end

    observe(@article_manager, "is_reading") do |old_value, new_value|
      if new_value
        start_playing
      else
        stop_playing
      end
    end
  end

  def on_toolbar_add_button_tapped
    add_to_bookmark
  end

  def on_toolbar_start_button_tapped
    if @article_manager.is_reading
      @article_manager.is_reading = false
    else
      if @article_manager.can_go_forward
        @article_manager.is_reading = true
      else
        open_channel_modal_view
      end
    end
  end

  def on_toolbar_preview_button_tapped
    open_preview_screen
  end

  def on_toolbar_action_button_tapped
    article = @article_manager.current_article
    if article
      text = article.title + " (#{article.host})"
      url = NSURL.URLWithString(article.link_url)

      activityView = URLActivityViewController.alloc.initWithDefaultActivities([text, url])
      self.presentViewController(activityView, animated:true, completion:nil)
    else
      App.alert("No article is selected.")
    end
  end

  def on_segmented_control_tapped(index)
    @speed_control_timer.invalidate unless @speed_control_timer.nil?
    case index
    when 0
      interval = [@article_manager.interval * 1.2, 30.0].min
    when 1
      interval = [@article_manager.interval * 0.8, 0.3].max
    end
    @article_manager.interval = interval
    App::Persistence[:interval] = interval
    SVProgressHUD.showProgress(interval/30, status: "Slide Interval: #{sprintf("%2.2f", interval.to_s)}")
    @speed_control_timer = NSTimer.scheduledTimerWithTimeInterval(2.0, 
                                                                  target: self, 
                                                                  selector: 'hide_speed_status', 
                                                                  userInfo: nil, 
                                                                  repeats: false)    
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
    if @article_manager.crawling_url_list_count > 0
      SVProgressHUD.showWithStatus("Loading...", maskType: SVProgressHUDMaskTypeBlack)
    end
    # if args[:model_saved]
    # end
  end

  def gesture_action(direction)
    case App::Persistence[direction]
    when RN::Const::SwipeLeft::START, RN::Const::SwipeRight::START
      start_reading
    when RN::Const::SwipeLeft::STOP, RN::Const::SwipeRight::STOP
      stop_reading
    when RN::Const::SwipeLeft::PREVIEW, RN::Const::SwipeRight::PREVIEW
      open_preview_screen
    when RN::Const::SwipeLeft::BOOKMARK, RN::Const::SwipeRight::BOOKMARK
      add_to_bookmark
    when RN::Const::SwipeLeft::SAFARI, RN::Const::SwipeRight::SAFARI
      UIApplication.sharedApplication.openURL(NSURL.URLWithString(@article_manager.current_article.link_url))
    when RN::Const::SwipeLeft::CHROME, RN::Const::SwipeRight::CHROME
      # sdk, urlscheme,  x-callback-url
    when RN::Const::SwipeLeft::TWEET, RN::Const::SwipeRight::TWEET
    when RN::Const::SwipeLeft::FACEBOOK, RN::Const::SwipeRight::FACEBOOK
    when RN::Const::SwipeLeft::POCKET, RN::Const::SwipeRight::POCKET
    # when RN::Const::SwipeLeft::READABILITY, RN::Const::SwipeRight::READABILITY
      true
    end
  end
end
