Teacup::Stylesheet.new :channels_screen do
  style :base_view,
    # backgroundColor: UIColor.whiteColor
    backgroundColor: BW.rgb_color(60, 60, 60)

  style :scroll_button,
    font: UIFont.systemFontOfSize(15),
    backgroundColor: BW.rgb_color(160, 160, 160)

  style :selected_tab,
    backgroundColor: BW.rgb_color(255, 160, 160)

  style :dissolved_tab,
    backgroundColor: BW.rgb_color(160, 160, 160)

  style :scroll_view,
    showsVerticalScrollIndicator: false,
    showsHorizontalScrollIndicator: false,
    bounces: false,
    left: 0,
    top:  60,
    width: App.frame.size.width,
    height: 44
  # constraints: [
  #   constrain_left(0),
  #   constrain_top(66),
  #   constrain_width(App.frame.size.width),
  #   constrain_height(44),
  # ]

  # style :table_view,
  #   height: App.frame.size.height - 44,
  #   width: App.frame.size.width,
  #   top: 44,
  #   left: 0
end
