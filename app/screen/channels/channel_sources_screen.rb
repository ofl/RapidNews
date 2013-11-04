class Channels::ChannelSourcesScreen < PM::Screen

  attr_accessor :channel_id

  stylesheet :channel_sources_screen

  def will_appear
    self.title = 'Sources'
    @categories = RN::Titles::CATEGORY
    @last_category_id = 0
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
    @tab_buttons = []
    cf = CGRectMake( 0,  0, 70 * @categories.length, 44)

    subview(UIScrollView.new, :scroll_view, {contentSize: cf.size, delegate: self}) do |s|
      subview UIView.new, {frame: cf}
      @categories.each do |k, v|
        button(:scroll_button, { frame: CGRectMake(70 * k, 0, 70, 44), tag: k + 1}).tap do |b|
          b.setTitle(v, forState: UIControlStateNormal)
          b.when(UIControlEventTouchUpInside) {
            unless  @last_category_id == k
              scroll_view_button_tapped(k)
              select_tab(k)
            end
          }
          @tab_buttons.push(b)
        end
      end
      @under_line_view = subview(UIView.new, :under_line_view, {})
    end
  end

  def set_table_view
    @table_screen ||= SourcesTableScreen.new(channel_id: @channel_id, category_id: @last_category_id)
    @table_screen.delegate = self
    subview @table_screen.view,
      frame: CGRectMake(0, 108, App.frame.size.width, Device.screen.height - 108)
  end
  
  def scrollViewDidScroll(scrollView)
    origin = scrollView.contentOffset
    scrollView.setContentOffset(CGPointMake(origin.x, 0.0))
  end

  def select_tab(index)
    @last_category_id = index
    UIView.animateWithDuration(0.40,
                               delay: 0.0,
                               options: UIViewAnimationOptionCurveEaseOut,
                               animations: -> {
                                 @under_line_view.frame = [[70 * index, 5], [70, 4]]
                               },
                               completion: nil)
  end

  def scroll_view_button_tapped(id)
    @table_screen.category_selected(id)
  end

  def open_feeds(link_url)
    open Channels::ChannelFeedsScreen.new({nav_bar: true, link_url: link_url})
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

  attr_accessor :category_id, :channel_id, :delegate

  def on_load
    @channel = Channel.find(@channel_id)    
  end

  def table_data
    @news_sources = NewsSource.where(:category).eq(@category_id).order(:position).all
    [{ cells: @news_sources.map{ |news_source| create_cell(news_source) } }]
  end

  def create_cell(news_source)
    registered = news_source.channels ? news_source.channels.include?(@channel_id) : false

    button = UIButton.new
    button.stylename = :disclosure_button
    button.when(UIControlEventTouchUpInside) { toggle_checked_button(news_source.url) }

    {
      cell_identifier: "Cell",
      cell_style: UITableViewCellStyleSubtitle,
      # indentationLevel: 2,
      title: news_source.name,
      subtitle: news_source.host,
      action: :on_cell_tapped,
      arguments: {id: news_source.id, link_url: news_source.url},
      subviews: [status_view(registered),button],
    }
  end

  def status_view(registered)
    UIView.new.tap do |v|
      v.frame = [[0, 0], [5, 44]]
      v.backgroundColor = registered ? BW.rgb_color(0,255,255) : BW.rgb_color(200,200,200)
    end
  end

  def category_selected(category_id)
    @category_id = category_id
    update_table_data
  end

  def on_disclosure_button_tapped(url)
    delegate.open_feeds(url)    
  end

  def on_cell_tapped(args={})
    news_source = NewsSource.find(args[:id])
    if news_source.channels && news_source.channels.include?(@channel.id)
      @channel.unregist(news_source)
    else
      @channel.regist(news_source)
    end
    update_table_data
  end
end
