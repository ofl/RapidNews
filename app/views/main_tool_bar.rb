# -*- coding: utf-8 -*-

class MainToolBar < UIToolbar

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
    self.stylesheet = :main_tool_bar
    self.barStyle = UIBarStyleBlack
    self.stylename = :base_view

    @start_button = button(:start_button).tap do |b|
      b.when(UIControlEventTouchUpInside) { on_start_button_tapped }
      b.setTitleColor BW.rgb_color(255, 255, 255), forState: UIControlStateHighlighted
      b.setTitleColor BW.rgb_color(40, 40, 40), forState: UIControlStateDisabled
      b.enabled = true
    end

    @slider = subview(UISlider.new, :slider).tap do |s|
      s.addTarget self, action: "on_slide:", forControlEvents: UIControlEventValueChanged
    end

    @counter_label = subview VerticallyAlignedLabel.new, :counter_label
    true
  end

  def refresh_view
    if @article_manager.count > 0
      @slider.maximumValue = @article_manager.count.to_f
      @slider.value = @article_manager.index.to_f + 1.0
      @slider.alpha = 1.0
      @slider.userInteractionEnabled = true
    else
      @slider.maximumValue = 0
      @slider.value = 0
      @slider.alpha = 0.5
      @slider.userInteractionEnabled = false
    end
    @counter_label.text = @article_manager.label_text
  end

  private
  
  def add_observers
    observe(@article_manager, "index") do |old_value, new_value|
      Dispatch::Queue.main.async { refresh_view }
    end

    observe(@article_manager, "count") do |old_value, new_value|
      Dispatch::Queue.main.async { refresh_view }
    end

    observe(@article_manager, "is_reading") do |old_value, new_value|
      @start_button.stylename = new_value ? :playing_button : :paused_button
    end
  end

  def show_article_at_index(timer)
    @article_manager.index = timer.userInfo.value.round - 1
  end

  # event listner

  def on_start_button_tapped
    if @article_manager.is_reading
      @article_manager.is_reading = false
    else
      if @article_manager.can_go_forward
        @article_manager.is_reading = true
      else
        self.delegate.confirm_load_article
      end
    end
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
