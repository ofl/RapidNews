Teacup::Stylesheet.new :channel_sources_screen do
  style :base_view,
    # backgroundColor: UIColor.whiteColor
    backgroundColor: UIColor.whiteColor

  style :scroll_button,
    font: UIFont.systemFontOfSize(12),
    backgroundColor: UIColor.whiteColor,
    titleColor: BW.rgb_color(60, 60, 60)

  style :scroll_view,
    showsVerticalScrollIndicator: false,
    showsHorizontalScrollIndicator: false,
    bounces: true,
    left: 0,
    top:  60,
    width: App.frame.size.width,
    height: 44

  style :under_line_view,
    left: 0,
    top:  5,
    width: 70,
    height: 4,
    backgroundColor: BW.rgb_color(0, 255, 255)
end
