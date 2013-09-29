class ChannelsScreen < PM::Screen
  stylesheet :channels_screen

  CrawlNewsSource = "CrawlNewsSource"

  def will_appear
    @channels = Channel.where(:is_checked).eq(true).order(:position).all
    @last_index = 0
    @view_is_set_up ||= set_up_view
  end

  def set_up_view
    layout(self.view, :base_view) do
      set_nav_bar_button :right, title: "Setting", action: :open_channel_settings
      set_nav_bar_button :left, system_item: :close, action: :on_close_button_tapped
      set_scroll_view
      set_table_view
    end
    true
  end

  def set_scroll_view
    @tab_buttons = []
    cf = CGRectMake( 0,  0, 70 * @channels.length, 44)

    subview(UIScrollView.new, :scroll_view, {contentSize: cf.size, delegate: self}) do |s|
      subview UIView.new, {frame: cf}
      @channels.each_with_index do |channel, i|
        button(:scroll_button, { frame: CGRectMake(70 * i, 7, 68, 38), tag: i + 1}).tap do |b|
          b.setTitle(channel.name, forState: UIControlStateNormal)
          b.when(UIControlEventTouchUpInside) {
            unless  @last_index == i
              scroll_view_button_tapped(channel.id)
              dissolve_tab
              select_tab(i)
            end
          }
          @tab_buttons.push(b)
        end
      end
      select_tab(@last_index)
    end
  end

  def set_table_view
    @table_screen ||= ChannelTableScreen.new
    subview @table_screen.view,
      frame: CGRectMake(0, 108, App.frame.size.width, Device.screen.height - 108)
  end
  
  def scrollViewDidScroll(scrollView)
    origin = scrollView.contentOffset
    scrollView.setContentOffset(CGPointMake(origin.x, 0.0))
  end

  def select_tab(index)
    @tab_buttons[index].stylename = :selected_tab
    @last_index = index
  end

  def dissolve_tab
    @tab_buttons[@last_index].stylename = :dissolved_tab
  end

  def scroll_view_button_tapped(id)
    @table_screen.channel_selected(id)
  end

  def open_channel_settings
    open Channels::SettingsScreen.new(nav_bar: true)
  end

  def on_close_button_tapped
    close()
  end

  def on_return(args = {})
    if args[:model_saved]
      @table_screen.update_table_data
    end
  end
end

class ChannelTableScreen < PM::TableScreen
  attr_accessor :channel_screen, :channel

  def table_data
    @channel ||= Channel.where(:is_checked).eq(true).order(:position).first
    @news_sources = @channel.news_sources.order(:position).all
    [{ cells: @news_sources.map{ |news_source| create_cell(news_source) } }]
  end

  def create_cell(news_source)
    {
      cell_identifier: "Cell",
      cell_style: UITableViewCellStyleValue1,
      title: news_source.name,
      subtitle: news_source.fetched_at.to_s || '',
      action: :on_cell_tapped,
      arguments: {id: news_source.id},
    }
  end

  def channel_selected(channel_id)
    @channel = Channel.find(channel_id)
    update_table_data
  end

  def crawl_news_sources(ids)
    # news_sources = NewsSource.where(:is_check).eq(true).all.map(&:id)
    BW::App.notification_center.post ChannelsScreen::CrawlNewsSource, Time.now, {ids: ids}
  end

  def on_cell_tapped(args={})
    crawl_news_sources [args[:id]]
  end
end
