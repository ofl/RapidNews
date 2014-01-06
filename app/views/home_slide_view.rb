# -*- coding: utf-8 -*-

class HomeSlideView < UIView

  attr_accessor :delegate

  FRAME_WIDTH = App.frame.size.width
  FRAME_HEIGHT = App.frame.size.height
  ORIGINAL_FRAME = CGRectMake(0,  0, FRAME_WIDTH, FRAME_HEIGHT)
  UPPER_FRAME = CGRectMake(0, -FRAME_HEIGHT, FRAME_WIDTH, FRAME_HEIGHT)

  def initWithFrame(frame)
    super.tap do
      userInteractionEnabled = true
      backgroundColor = UIColor.blackColor

      @article_manager = ArticleManager.instance
      @view_stack = []
      @current_num = 0
      @upper_num = nil
      @lower_num = nil

      add_gesture_recognizer
    end
  end

  # show

  def set_article_at_index(index)
    index = index < @article_manager.count ? index : 0
    max_index = [index + 1, @article_manager.count - 1].min
    min_index = [index - 1, 0].max

    push_article(index) if @view_stack.count == 0
    add_next_article min_index, max_index
    add_prev_article min_index, max_index
    sweep_after_articles max_index
    sweep_before_articles min_index
    update_index(index)
  end

  def update_article_at_indx(index)
    @view_stack[0].update_article(index)    
  end

  def update_articles
    @view_stack.each do |view|
      view.update_article(nil)
    end
  end

  def update_index(index)
    @upper_num = nil
    @lower_num = nil

    @view_stack.each_with_index do |view, i|
      if view.index == index
        @current_num = i
      elsif view.index == index - 1
        @upper_num = i
      elsif view.index == index + 1
        @lower_num = i
      end
    end
  end

  # add article_views that are missing on left side
  def add_prev_article(min_index, max_index)
    first_article_view = @view_stack[0]
    upper_index = first_article_view.index

    while upper_index > min_index
      upper_index -= 1
      next if upper_index > max_index
      shift_article upper_index
    end
  end

  # add article_views that are missing on right side
  def add_next_article(min_index, max_index)
    last_article_view = @view_stack.lastObject
    lower_index = last_article_view.index

    while lower_index < max_index
      lower_index += 1
      next if lower_index < min_index
      push_article lower_index
    end
  end

  # remove article_views that have fallen off left edge
  def sweep_before_articles(min_index)
    first_article_view = @view_stack[0]

    while first_article_view.index < min_index
      first_article_view.removeFromSuperview
      @view_stack.removeObjectAtIndex 0
      first_article_view = @view_stack[0]
    end
  end

  # remove article_views that have fallen off right edge
  def sweep_after_articles(max_index)
    last_article_view = @view_stack.lastObject

    while last_article_view.index > max_index
      last_article_view.removeFromSuperview
      @view_stack.removeLastObject
      last_article_view = @view_stack.lastObject
    end
  end

  def shift_article(index)
    frame = index < @article_manager.index ? UPPER_FRAME : ORIGINAL_FRAME
    view = HomeArticleView.alloc.initWithFrame(frame)
    view.update_article(index)
    addSubview(view)
    @view_stack.insertObject view, atIndex: 0
    view
  end

  def push_article(index)
    view = HomeArticleView.alloc.initWithFrame(ORIGINAL_FRAME)
    view.update_article(index)
    insertSubview view, atIndex: 0
    @view_stack.addObject(view)
    view
  end

  def pop_view_except_current
    if @view_stack.count > 1
      current_view = @view_stack[@current_num]
      @view_stack.each_with_index do |view|
        view.removeFromSuperview
        @view_stack.delete view
      end
    end
  end

  # animation

  def slide_up
    current_view = @view_stack[@current_num]
    lower_view = @view_stack[@lower_num]
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
    current_view = @view_stack[@current_num]
    upper_view = @view_stack[@upper_num]
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

    current_view = @view_stack[@current_num]
    upper_view = @upper_num ? @view_stack[@upper_num] : nil
    lower_view = @lower_num ? @view_stack[@lower_num] : nil

    if offset > 0
      move_down current_view, upper_view, offset
    else
      move_up current_view, lower_view, offset
    end
  end

  def touchesEnded(touches, withEvent: event)
    return if @view_stack.count < 1 || @article_manager.is_reading
    offset = touches.anyObject.locationInView(self).y - @beginY

    current_view = @view_stack[@current_num]
    upper_view = @upper_num ? @view_stack[@upper_num] : nil
    lower_view = @lower_num ? @view_stack[@lower_num] : nil

    if offset < 44 && offset > -44
      return_default_position current_view, upper_view, lower_view
      delegate.toggle_toolbar if offset < 5 && offset > -5
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
  # current_viewをoffsetの0.25倍の距離下げる
  def move_down(current_view, upper_view, offset)
    if upper_view
      upper_view.frame = CGRectMake(0, offset * 2 - FRAME_HEIGHT, FRAME_WIDTH, FRAME_HEIGHT)
      current_view.alpha = 1.0 - (0.25 * offset / FRAME_HEIGHT)
    else
      current_view.frame = CGRectMake(0, offset * 0.25, FRAME_WIDTH, FRAME_HEIGHT)
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
      current_view.frame = CGRectMake(0, offset * 0.25, FRAME_WIDTH, FRAME_HEIGHT)
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
      delegate.toggle_toolbar
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
      delegate.open_channel_modal_view
    end
  end

  def touchesCancelled(touches, withEvent: event)
    # p 'stay'
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
      delegate.gesture_action('swipe_right')
    when UISwipeGestureRecognizerDirectionLeft
      delegate.gesture_action('swipe_left')
    end
  end
end
