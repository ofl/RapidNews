Teacup::Stylesheet.new :channels_modal_view do
  style :base_view,
    backgroundColor: BW.rgba_color(255, 255, 255, 0.80),
    frame: CGRectMake( 0, 0, App.frame.size.width, 150)

  style :cancel_button,
    frame: CGRectMake( 0, 106, App.frame.size.width, 44),
    font: UIFont.systemFontOfSize(20.0)

  style :scroll_view,
    showsVerticalScrollIndicator: false,
    showsHorizontalScrollIndicator: false,
    left: 0,
    top:  0,
    width: App.frame.size.width,
    height: 100

  style :channel_button,
    backgroundColor: BW.rgb_color(150, 150, 150)

  style :channel_label,
    textAlignment: UITextAlignmentCenter,
    textColor: BW.rgb_color(40, 40, 40),
    font: UIFont.systemFontOfSize(9.0)
end
