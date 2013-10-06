# -*- coding: utf-8 -*-

class MainSlideView < UIView

  include BW::KVO
  attr_accessor :delegate

  FRAME_WIDTH = App.frame.size.width
  FRAME_HEIGHT = App.frame.size.height
  ORIGINAL_FRAME = CGRectMake(0,  0, FRAME_WIDTH, FRAME_HEIGHT)
  UPPER_FRAME = CGRectMake(0, -FRAME_HEIGHT, FRAME_WIDTH, FRAME_HEIGHT)
  THRESHOLD = 1.0

  def initWithFrame(frame)
    super.tap do
      userInteractionEnabled = true
      backgroundColor = UIColor.blackColor

      @article_manager = ArticleManager.instance
      @view_stack = []
      @timer = nil
      @current_idx = 0
      @upper_idx = nil
      @lower_idx = nil
      @beginY = 0
      @interval = 3.0

      add_observers
      add_gesture_recognizer
    end
  end

  # show

  def set_article_at_index(index)
    return if @article_manager.count == 0

    if @interval > THRESHOLD
      index = index < @article_manager.count ? index : 0
      max_index = [index + 1, @article_manager.count - 1].min
      min_index = [index - 1, 0].max

      push_article(index) if @view_stack.count == 0
      add_next_article min_index, max_index
      add_prev_article min_index, max_index
      sweep_after_articles max_index
      sweep_before_articles min_index
      update_index(index)
    else
      @view_stack[0].update_article(@article_manager.index)
    end
  end

  def update_index(index)
    @upper_idx = nil
    @lower_idx = nil

    @view_stack.each_with_index do |view, i|
      if view.index == index
        @current_idx = i
      elsif view.index == index - 1
        @upper_idx = i
      elsif view.index == index + 1
        @lower_idx = i
      end
    end
  end

  # add article_views that are missing on left side
  def add_prev_article(min_index, max_index)
    first_article = @view_stack[0]
    upper_index = first_article.index

    while upper_index > min_index
      upper_index -= 1
      next if upper_index > max_index
      shift_article upper_index
    end
  end

  # add article_views that are missing on right side
  def add_next_article(min_index, max_index)
    last_article = @view_stack.lastObject
    lower_index = last_article.index

    while lower_index < max_index
      lower_index += 1
      next if lower_index < min_index
      push_article lower_index
    end
  end

  # remove article_views that have fallen off left edge
  def sweep_before_articles(min_index)
    first_article = @view_stack[0]

    while first_article.index < min_index
      first_article.removeFromSuperview
      @view_stack.removeObjectAtIndex 0
      first_article = @view_stack[0]
    end
  end

  # remove article_views that have fallen off right edge
  def sweep_after_articles(max_index)
    last_article = @view_stack.lastObject

    while last_article.index > max_index
      last_article.removeFromSuperview
      @view_stack.removeLastObject
      last_article = @view_stack.lastObject
    end
  end

  def shift_article(index)
    frame = index < @article_manager.index ? UPPER_FRAME : ORIGINAL_FRAME
    view = MainArticleView.alloc.initWithFrame(frame)
    view.update_article(index)
    addSubview(view)
    @view_stack.insertObject view, atIndex: 0
    view
  end

  def push_article(index)
    view = MainArticleView.alloc.initWithFrame(ORIGINAL_FRAME)
    view.update_article(index)
    insertSubview view, atIndex: 0
    @view_stack.addObject(view)
    view
  end

  def pop_view_except_current
    current_view = @view_stack[@current_idx]
    @view_stack.each_with_index do |view|
      view.removeFromSuperview
      @view_stack.delete view
    end
  end

  # animation

  def slide_up
    current_view = @view_stack[@current_idx]
    lower_view = @view_stack[@lower_idx]
    UIView.animateWithDuration(0.25,
                               delay: 0.0,
                               options: UIViewAnimationOptionCurveEaseOut,
                               animations: -> {
                                 current_view.frame = UPPER_FRAME
                                 lower_view.alpha = 1.0
                               },
                               completion: -> (finished) {
                                 @article_manager.index = current_view.index + 1
                               }
                               )
  end

  def slide_down
    current_view = @view_stack[@current_idx]
    upper_view = @view_stack[@upper_idx]
    UIView.animateWithDuration(0.25,
                               delay: 0.0,
                               options: UIViewAnimationOptionCurveEaseOut,
                               animations: -> {
                                 upper_view.frame = ORIGINAL_FRAME
                                 current_view.alpha = 0.75
                               },
                               completion: -> (finished) {
                                 @article_manager.index = upper_view.index
                               }
                               )
  end

  # Delegate

  def gestureRecognizer(gestureRecognizer, shouldReceiveTouch:touch)
    return true
  end

  def touchesBegan(touches, withEvent: event)
    @beginY = touches.anyObject.locationInView(self).y
  end

  def touchesMoved(touches, withEvent: event)
    return if @view_stack.count < 1 || @article_manager.is_reading
    offset = touches.anyObject.locationInView(self).y - @beginY

    current_view = @view_stack[@current_idx]
    upper_view = @upper_idx ? @view_stack[@upper_idx] : nil
    lower_view = @lower_idx ? @view_stack[@lower_idx] : nil

    if offset > 0
      move_down current_view, upper_view, offset
    else
      move_up current_view, lower_view, offset
    end
  end

  def touchesEnded(touches, withEvent: event)
    return if @view_stack.count < 1 || @article_manager.is_reading
    offset = touches.anyObject.locationInView(self).y - @beginY

    current_view = @view_stack[@current_idx]
    upper_view = @upper_idx ? @view_stack[@upper_idx] : nil
    lower_view = @lower_idx ? @view_stack[@lower_idx] : nil

    if offset < 44 && offset > -44
      return_default_position current_view, upper_view, lower_view
      delegate.show_controller if offset < 5 && offset > -5
    elsif offset > 0
      return_default_position(current_view, upper_view, lower_view) unless upper_view
      pull_down current_view, upper_view, offset
    else
      return_default_position(current_view, upper_view, lower_view) unless lower_view
      pull_up current_view, lower_view, offset
    end
  end

  # 下に引く
  # upper_viewがあれば
  # 1, upper_viewをoffsetの2倍の距離下げる
  # 2, current_viewのalpha値を下げる
  # なければ(最初)
  # current_viewをoffsetの半分の距離下げる
  def move_down(current_view, upper_view, offset)
    if upper_view
      upper_view.frame = CGRectMake(0, offset * 2 - FRAME_HEIGHT, FRAME_WIDTH, FRAME_HEIGHT)
      current_view.alpha = 1.0 - (0.25 * offset / FRAME_HEIGHT)
    else
      current_view.frame = CGRectMake(0, offset * 0.5, FRAME_WIDTH, FRAME_HEIGHT)
    end
  end

  # 上に引く
  # lower_viewがあれば
  # 1, current_viewをoffsetの等倍の距離上げる
  # 2, current_viewのalpha値を上げる
  # なければ(最後)
  # current_viewをoffsetの半分の距離上げる
  def move_up(current_view, lower_view, offset)
    if lower_view
      current_view.frame = CGRectMake(0, offset, FRAME_WIDTH, FRAME_HEIGHT)
      lower_view.alpha = 0.75 - (0.25 * offset / FRAME_HEIGHT)
    else
      current_view.frame = CGRectMake(0, offset * 0.5, FRAME_WIDTH, FRAME_HEIGHT)
    end
  end

  # もとに戻す
  # offset < 44
  # current_viewはもとに戻す
  # current_viewのalphaは 1.0
  # upper_viewがあれば
  #   upper_viewのframeをUPPER_FRAMEに戻す
  #   upper_viewのalphaは1.0
  # lower_viewがあれば
  #   upper_viewのalphaは0.75
  def return_default_position(current_view, upper_view, lower_view)
    current_view.frame = ORIGINAL_FRAME
    current_view.alpha = 1.0
    upper_view.frame = UPPER_FRAME if upper_view
    upper_view.alpha = 1.0 if upper_view
    lower_view.alpha = 0.75 if lower_view
  end

  # 下で離す
  # upper_viewがあれば
  #   slide_down
  # なければ
  #   コントローラーを表示
  def pull_down(current_view, upper_view, offset)
    if upper_view
      slide_down
    else
      delegate.show_controller
    end
  end

  # 上で離す
  # lower_viewがあれば
  #   slide_up
  # なければ
  #   action sheetを表示
  def pull_up(current_view, lower_view, offset)
    if lower_view
      slide_up
    else
      delegate.confirm_load_article
    end
  end

  def touchesCancelled(touches, withEvent: event)
    p 'stay'
  end

  #control

  def show_next_article
    if @article_manager.index < @article_manager.count - 1
      adjust_interval
      if @interval > THRESHOLD
        slide_up
      else
        pop_view_except_current if @view_stack.count > 1
        @article_manager.index = @article_manager.index + 1
      end
      set_timer
    else
      @article_manager.is_reading = false
    end
  end

  def add_observers
    observe(@article_manager, "count") do |old_value, new_value|
      Dispatch::Queue.main.async{
        set_article_at_index(@article_manager.index)
      }
    end

    observe(@article_manager, "index") do |old_value, new_value|
      Dispatch::Queue.main.async{
        set_article_at_index(@article_manager.index)
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
        set_article_at_index(@article_manager.index)
      end
    end
    @interval = @article_manager.interval > 2.0 ? @article_manager.interval : 2.0
  end

  # Gesture

  def add_gesture_recognizer
    [UISwipeGestureRecognizerDirectionRight, UISwipeGestureRecognizerDirectionLeft].each do |direction|
      recognizer = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:'on_view_swiped:')
      recognizer.direction = direction
      recognizer.delegate = self
      addGestureRecognizer(recognizer)
    end
  end

  def on_view_swiped(recognizer)
    case recognizer.direction
    when UISwipeGestureRecognizerDirectionRight
      # gesture_action('swipe_up')
    when UISwipeGestureRecognizerDirectionLeft
      # gesture_action('swipe_down')
    end
  end

  def gesture_action(direction)
    case App::Persistence[direction]
    when RN::Const::SwipeAction::START
      start_reading
    when RN::Const::SwipeAction::STOP
      stop_reading
    when RN::Const::SwipeAction::PREVIEW
      open_preview_screen
    when RN::Const::SwipeAction::BOOKMARK
      add_to_bookmarked
    when RN::Const::SwipeAction::SAFARI
      UIApplication.sharedApplication.openURL(NSURL.URLWithString(@article_manager.displaying.link_url))
    when RN::Const::SwipeAction::CHROME
      # sdk, urlscheme,  x-callback-url
    when RN::Const::SwipeAction::TWEET
    when RN::Const::SwipeAction::FACEBOOK
    when RN::Const::SwipeAction::POCKET
    when RN::Const::SwipeAction::READABILITY
      true
    end
  end
end
