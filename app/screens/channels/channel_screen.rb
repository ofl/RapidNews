class Channels::ChannelScreen < PM::Screen

  attr_accessor :channel

  stylesheet :channel_screen

  def on_load
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
      b.setTitle(BW::localized_string(:registered, 'Rgistered'), forState: UIControlStateNormal)
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
    [{ cells: @news_sources.map.with_index{ |news_source, index| create_cell(news_source, index) } }]
  end

  def create_cell(news_source, index)
    registered = news_source.channels ? news_source.channels.include?(@channel.id) : false
    button = UIButton.new
    if @category_id.nil?
      button.addTarget(self, action:'delete_row:', forControlEvents:UIControlEventTouchUpInside)
    else
      button.addTarget(self, action:'toggle_checked_button:', forControlEvents:UIControlEventTouchUpInside)
    end
    if registered
      set_attributes button, {stylename: :checked_button}
    else
      set_attributes button, {stylename: :not_checked_button}
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
        textColor: RN::Const::Color::DETAIL,
        font: UIFont.systemFontOfSize(10.0)
      }
    }
  end

  def category_selected(category_id)
    @category_id = category_id
    update_table_data
  end

  def delete_row(button)
    index_path = table_view.indexPathForCell(button.superview.superview)
    index = index_path.indexAtPosition(index_path.length - 1)
    news_source = @news_sources[index]
    return unless news_source

    if news_source.channels && news_source.channels.include?(@channel.id)
      @channel.unregist(news_source)
      @news_sources.delete(news_source)
      self.promotion_table_data.delete_cell(index_path: index_path)
      table_view.deleteRowsAtIndexPaths([index_path], withRowAnimation:UITableViewRowAnimationRight)
    end
  end


  def toggle_checked_button(button)
    index_path = table_view.indexPathForCell(button.superview.superview)
    index = index_path.indexAtPosition(index_path.length - 1)
    news_source = @news_sources[index]
    return unless news_source

    if news_source.channels && news_source.channels.include?(@channel.id)
      @channel.unregist(news_source)
    else
      @channel.regist(news_source)
    end
    update_table_data    
  end

  # def toggle_checked_button(news_source, index)
  #   if news_source.channels && news_source.channels.include?(@channel.id)
  #     @channel.unregist(news_source)
  #     # delete_row(NSIndexPath.indexPathForRow(index, inSection:0))

  #     sender = table_view.viewWithTag(index + 1)

  #     p index + 1

  #     # index_path = sender.superview.superview.superview.indexPathForCell(sender.superview.superview)
  #     index_path = table_view.indexPathForCell(sender.superview)

  #     # index_path = NSIndexPath.indexPathForRow(index, inSection:0)

  #     self.promotion_table_data.delete_cell(index_path: index_path)

  #     table_view.deleteRowsAtIndexPaths([index_path], withRowAnimation:UITableViewRowAnimationRight)
  #   else
  #     @channel.regist(news_source)
  #     update_table_data    
  #   end
  # end

  def on_cell_tapped(args={})
    delegate.open_feeds(args[:news_source_id])    
  end
end
