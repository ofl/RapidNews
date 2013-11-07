Teacup::Stylesheet.new :channel_screen do
  style :base_view,
    # backgroundColor: UIColor.whiteColor
    backgroundColor: UIColor.whiteColor

  style :registered_button,
    font: UIFont.systemFontOfSize(12),
    backgroundColor: UIColor.whiteColor,
    titleColor: BW.rgb_color(60, 60, 60)

  style :scroll_button,
    font: UIFont.systemFontOfSize(12),
    backgroundColor: UIColor.whiteColor,
    titleColor: BW.rgb_color(60, 60, 255)

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

  style :button,
    height: 42,
    width: 50,
    top: 1,
    left: 0,
    title: 0xe6c7.chr(Encoding::UTF_8),
    font: UIFont.fontWithName("ionicons", size:20.0),
    titleColor: BW.rgb_color(200,200,200)

  style :checked_button, extends: :button,
    titleColor: BW.rgb_color(0,150,255)

  style :nochecked_button, extends: :button,
    titleColor: BW.rgb_color(230,230,230)


end
