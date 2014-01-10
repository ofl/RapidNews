# -*- coding: utf-8 -*-

class HomeToolBar < TransparentToolbar

  include BW::KVO

  def initWithFrame(frame)
    super.tap do
      @article_manager = ArticleManager.instance
      @timer = nil

      @view_setup ||= set_up_view
      add_observers
    end
  end

  def set_up_view
    self.stylesheet = :home_tool_bar
    # self.barStyle = UIBarStyleBlack
    self.stylename = :base_view

    spacer = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace,
                                                               target: nil,
                                                               action: nil)

    @action_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAction,
                                                                      target: self,
                                                                      action: "on_action_button_tapped")

    start_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemPlay,
                                                                     target: self,
                                                                     action: "on_start_button_tapped")

    pause_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemPause,
                                                                     target: self,
                                                                     action: "on_start_button_tapped")

    @add_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd,
                                                                   target: self,
                                                                   action: "on_add_button_tapped")

    @preview_button = UIBarButtonItem.alloc.initWithImage(UIImage.imageNamed('images/right2.png'),
                                                         style: UIBarButtonItemStylePlain,
                                                         target: self,
                                                         action: "on_preview_button_tapped")

    @playing_buttons = [@add_button, spacer, pause_button, spacer, @action_button, spacer, @preview_button]
    @pausing_buttons = [@add_button, spacer, start_button, spacer, @action_button, spacer, @preview_button]


    @transparent_toolbar = subview(TransparentToolbar, :clear_toolbar).tap do |t|
      t.items = @pausing_buttons
    end

    image = UIImage.imageNamed('images/slide_thumb.png')
    thumb_image = image.tintedImageWithColor(RN::Const::Color::TINT)

    @slider = subview(UISlider.new, :slider).tap do |s|
      s.addTarget self, action: "on_slide:", forControlEvents: UIControlEventValueChanged
      s.setThumbImage(thumb_image, forState: UIControlStateNormal)
      s.setThumbImage(thumb_image, forState: UIControlStateHighlighted)
    end

    @counter_label = subview VerticallyAlignedLabel.new, :counter_label

    segmented_control = subview UISegmentedControl.alloc.initWithItems(['+', '-']), :segmented_control
    segmented_control.addTarget(self, action: 'on_segmented_control_tapped:', forControlEvents: UIControlEventValueChanged)
    true
  end

  def refresh_view
    if @article_manager.count > 0
      enable_buttons
      @add_button.enabled = @article_manager.current_article.is_bookmarked ? false : true
      @slider.minimumValue = 1.0
      @slider.maximumValue = @article_manager.count.to_f
      @slider.value = @article_manager.index.to_f + 1.0
      @slider.alpha = 1.0
      @slider.userInteractionEnabled = true
    else
      disaable_buttons      
      @slider.minimumValue = 0
      @slider.maximumValue = 0
      @slider.value = 0
      @slider.alpha = 0.5
      @slider.userInteractionEnabled = false
    end
    @counter_label.text = @article_manager.label_text
  end

  private

  def enable_buttons
    @action_button.enabled = true
    @preview_button.enabled = true
  end

  def disaable_buttons
    @add_button.enabled = false
    @action_button.enabled = false
    @preview_button.enabled = false    
  end

  def add_observers
    observe(@article_manager, "index") do |old_value, new_value|
      Dispatch::Queue.main.async { refresh_view }
    end

    observe(@article_manager, "count") do |old_value, new_value|
      Dispatch::Queue.main.async { refresh_view }
    end

    observe(@article_manager, "is_reading") do |old_value, new_value|
      @transparent_toolbar.items = new_value ? @playing_buttons : @pausing_buttons
    end
  end

  def show_article_at_index(timer)
    @article_manager.index = timer.userInfo.value.round - 1
  end

  # event listner

  def on_action_button_tapped
    self.delegate.on_toolbar_action_button_tapped
  end

  def on_start_button_tapped
    self.delegate.on_toolbar_start_button_tapped
  end

  def on_preview_button_tapped
    self.delegate.on_toolbar_preview_button_tapped
  end

  def on_add_button_tapped
    @add_button.enabled = false
    self.delegate.on_toolbar_add_button_tapped
  end

  def on_segmented_control_tapped(segment)
    self.delegate.on_segmented_control_tapped(segment.selectedSegmentIndex)
  end

  def on_slide(args)
    if @timer
      @timer.invalidate
      @timer = nil
    end
    @timer = NSTimer.scheduledTimerWithTimeInterval(0.4,
                                                    target: self,
                                                    selector: 'show_article_at_index:',
                                                    userInfo: args,
                                                    repeats: false)
  end
end
