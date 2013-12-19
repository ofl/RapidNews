class Channels::ChannelScreen < PM::Screen

  attr_accessor :channel

  stylesheet :channel_screen

  def will_appear
    self.title = @channel.name
    @categories = RN::Titles::CATEGORY
    @view_is_set_up ||= set_up_view
  end

  def set_up_view
    layout(self.view, :base_view) do
      set_scroll_view
      set_table_view
    end
    true
  end

  def set_scroll_view
    cf = CGRectMake( 0,  0, 70 * (@categories.length), 44)
    @registered_button = button(:registered_button, { frame: CGRectMake(0, 60, 70, 44) }).tap do |b|
      b.setTitle('registered', forState: UIControlStateNormal)
      b.when(UIControlEventTouchUpInside) {
        @under_line_view.stylename = :under_line_view_blured
        @content_view.stylename = :tab_blured
        @registered_button.stylename = :tab_selected
        scroll_view_button_tapped(nil)
      }
    end

    subview(UIScrollView.new, :scroll_view, {contentSize: cf.size, delegate: self}) do |s|
      @content_view = subview UIView.new, :content_view, {frame: cf}
      @categories.each do |k, v|
        button(:scroll_button, { frame: CGRectMake(70 * k, 0, 70, 44), tag: k + 1}).tap do |b|
          b.setTitle(v, forState: UIControlStateNormal)
          b.when(UIControlEventTouchUpInside) {
            scroll_view_button_tapped(k)
            select_tab(k)
          }
        end
      end
      @under_line_view = subview(UIView.new, :under_line_view, {})
    end
  end

  def set_table_view
    @table_screen ||= SourcesTableScreen.new(channel: @channel)
    @table_screen.tableView.setSeparatorInset(UIEdgeInsetsMake(43, 55, 0, 2))
    @table_screen.delegate = self
    subview @table_screen.view,
      frame: CGRectMake(0, 108, App.frame.size.width, Device.screen.height - 108)
  end
  
  def scrollViewDidScroll(scrollView)
    origin = scrollView.contentOffset
    scrollView.setContentOffset(CGPointMake(origin.x, 0.0))
  end

  def select_tab(index)
    @under_line_view.stylename = :under_line_view_selected
    @content_view.stylename = :tab_selected
    @registered_button.stylename = :tab_blured
    UIView.animateWithDuration(0.40,
                               delay: 0.0,
                               options: UIViewAnimationOptionCurveEaseOut,
                               animations: -> {
                                 @under_line_view.frame = [[70 * index, 40], [70, 4]]
                               },
                               completion: nil)
  end

  def scroll_view_button_tapped(id)
    @table_screen.category_selected(id)
  end

  def open_feeds(news_source_id)
    open Channels::NewsSourceScreen.new({nav_bar: true, id: news_source_id})
  end

  def on_close_button_tapped
    close()
  end

  def on_return(args = {})
    if args[:model_saved]
      @table_screen.update_table_data
    end
  end

  def will_dismiss
    self.parent_screen.on_return(model_saved: true)
  end
end

class SourcesTableScreen < PM::TableScreen

  stylesheet :channel_sources_screen

  attr_accessor :category_id, :channel, :delegate

  def table_data
    if @category_id.nil?    
      @news_sources = @channel.news_sources
    else
      @news_sources = NewsSource.where(:category).eq(@category_id).all
    end
    [{ cells: @news_sources.map{ |news_source| create_cell(news_source) } }]
  end

  def create_cell(news_source)
    registered = news_source.channels ? news_source.channels.include?(@channel.id) : false

    button = UIButton.new
    button.when(UIControlEventTouchUpInside) { toggle_checked_button(news_source) }
    if registered
      set_attributes button, {stylename: :checked_button}
    else
      set_attributes button, {stylename: :nochecked_button}
    end

    {
      cell_identifier: "Cell",
      cell_class: PM::TableViewCell,
      cell_style: UITableViewCellStyleSubtitle,
      # indentationLevel: 2,
      title: news_source.name,
      subtitle: news_source.host,
      action: :on_cell_tapped,
      selectionStyle: UITableViewCellSelectionStyleGray,
      accessoryType: UITableViewCellAccessoryDisclosureIndicator,
      arguments: {news_source_id: news_source.id},
      subviews: [button],
      textLabel: {
        font: UIFont.systemFontOfSize(13.0)
      },
      detailTextLabel: {
        frame: CGRectMake(35, 32, 150, 12),
        textColor: BW.rgb_color(120,120,120),
        font: UIFont.systemFontOfSize(10.0)
      }
    }
  end

  def category_selected(category_id)
    @category_id = category_id
    update_table_data
  end

  def toggle_checked_button(news_source)
    if news_source.channels && news_source.channels.include?(@channel.id)
      @channel.unregist(news_source)
    else
      @channel.regist(news_source)
    end
    update_table_data    
  end

  def on_cell_tapped(args={})
    delegate.open_feeds(args[:news_source_id])    
  end
end