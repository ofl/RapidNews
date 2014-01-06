class Preview::RootScreen < PM::WebScreen

  stylesheet :preview_screen

  QVToolBarScrollStatusInit = 0
  QVToolBarScrollStatusAnimation = 1

  attr_accessor :article, :is_modal

  def on_load
    @url = @article.link_url
    @page_title = @article.title
    @beginScrollOffsetY = 0
    @toolbarScrollStatus = QVToolBarScrollStatusInit
    @toolbar_hidden = false    
  end

  def will_appear
    @view_is_set_up ||= set_up_view
  end

  def will_disappear
    webview.delegate = nil
    webview.stopLoading
  end

  def set_up_view
    layout(self.view, :base_view)  do
      self.webview.stylename = :webview
      self.navigationController.navigationBarHidden = false
      self.navigationController.setToolbarHidden(false, animated:false)
      self.automaticallyAdjustsScrollViewInsets = false

      self.navigationItem.titleView = UIView.new.tap do |t|
        t.frame = [[0, 0], [App.frame.size.width - 100, 40]]

        @title_label = VerticallyAlignedLabel.new.tap do |tl|
          tl.frame = [[0, 2], [App.frame.size.width - 100, 20]]
          tl.textAlignment = UITextAlignmentCenter
          tl.textColor = UIColor.blackColor
          tl.font = UIFont.systemFontOfSize(14.0)
          t.addSubview tl
        end

        @url_label = VerticallyAlignedLabel.new.tap do |ul|
          ul.frame = [[0, 20], [App.frame.size.width - 100, 20]]
          ul.textAlignment = UITextAlignmentCenter
          ul.textColor = BW.rgb_color(150,150,150)
          ul.font = UIFont.systemFontOfSize(10.0)
          t.addSubview ul
        end
      end
      self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemRefresh,
                                                                               target: self,
                                                                               action: "on_refresh_tapped")
      if is_modal
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemStop,
                                                                                target: self,
                                                                                action: "close_screen")
      end

      @toolbar = self.navigationController.toolbar
      @button_is_set_up ||= set_up_buttons
      set_scroll_view_delegate
    end
    true
  end

  def set_up_buttons
    spacer = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace,
                                                               target:nil,
                                                               action:nil)

    @back_button = UIBarButtonItem.alloc.initWithImage(UIImage.imageNamed('images/back'),
                                                       style:UIBarButtonItemStylePlain,
                                                       target:self,
                                                       action:"on_back_button_tapped")
    @back_button.enabled = false

    @forward_button = UIBarButtonItem.alloc.initWithImage(UIImage.imageNamed('images/forward'),
                                                          style:UIBarButtonItemStylePlain,
                                                          target:self,
                                                          action:"on_forward_button_tapped")
    @forward_button.enabled = false

    share_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAction,
                                                                     target: self,
                                                                     action: "open_activity")

    self.setToolbarItems([@back_button, spacer, @forward_button, spacer,
                          share_button, spacer, spacer, spacer, spacer])
    true
  end

  def set_scroll_view_delegate
    scroll_view = self.webview.scrollView
    scroll_view.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    scroll_view.setContentOffset(CGPointMake(0, self.navigationController.navigationBar.frame.origin.y), animated: false)
    scroll_view.showsHorizontalScrollIndicator = false
    scroll_view.delegate = self
  end

  def content
    NSURL.URLWithString(@article.link_url)
  end

  def load_started
    # Optional
    # Called when the request starts to load
  end

  def load_finished
    @page_title = self.webview.stringByEvaluatingJavaScriptFromString("document.title")
    @url = self.webview.stringByEvaluatingJavaScriptFromString("document.URL")
    @title_label.text = @page_title
    @url_label.text = @url
    @back_button.enabled = self.can_go_back ? true : false
    @forward_button.enabled = self.can_go_forward ? true : false
  end

  def load_failed(error)
    @url = ''
    @page_title = error
  end

  def open_activity
    if @url
      activityView = URLActivityViewController.alloc.initWithDefaultActivities([@page_title, NSURL.URLWithString(@url)])
      self.presentViewController(activityView, animated:true, completion:nil)
    else
      App.alert("No url is selected.")
    end
  end

  def scrollViewWillBeginDragging(scrollView)
    @beginScrollOffsetY = scrollView.contentOffset.y
  end

  def scrollViewDidScroll(scrollView)
    return if QVToolBarScrollStatusAnimation == @toolbarScrollStatus

    r = @toolbar.frame
    if @beginScrollOffsetY < scrollView.contentOffset.y && !@toolbar_hidden
      frame = CGRectMake(r.origin.x, self.view.bounds.size.height, r.size.width, r.size.height)

      UIView.animateWithDuration( 0.4,
                                  animations: -> {
                                    @toolbarScrollStatus = QVToolBarScrollStatusAnimation
                                    @toolbar.frame = frame
                                  },
                                  completion: -> (finished){
                                    @toolbar_hidden = true
                                    @toolbarScrollStatus = QVToolBarScrollStatusInit
                                  }
                                  )
    elsif scrollView.contentOffset.y < @beginScrollOffsetY && @toolbar_hidden && 0.0 != @beginScrollOffsetY
      @toolbar_hidden = false
      frame = CGRectMake(r.origin.x, self.view.bounds.size.height - r.size.height, r.size.width, r.size.height)

      UIView.animateWithDuration( 0.4,
                                  animations: -> {
                                    @toolbarScrollStatus = QVToolBarScrollStatusAnimation
                                    @toolbar.frame = frame
                                  },
                                  completion: -> (finished){
                                    @toolbarScrollStatus = QVToolBarScrollStatusInit
                                  }
                                  )
    end
  end

  def on_forward_button_tapped
    self.forward
  end

  def on_refresh_tapped
    self.refresh
  end

  def on_back_button_tapped
    self.back
  end

  def close_screen
    self.close_modal_screen
  end
end
