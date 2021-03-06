Teacup::Stylesheet.new :channel_screen do
  style :base_view,
    # backgroundColor: UIColor.whiteColor
    backgroundColor: UIColor.whiteColor

  style :content_view,
    backgroundColor: RN::Const::Color::DISABLE

  style :registered_button,
    font: UIFont.systemFontOfSize(12),
    backgroundColor: UIColor.whiteColor,
    titleColor: BW.rgb_color(60, 60, 60)

  style :scroll_button,
    font: UIFont.systemFontOfSize(12),
    titleColor: BW.rgb_color(60, 60, 255)

  style :tab_blured,
    backgroundColor: RN::Const::Color::DISABLE

  style :tab_selected,
    backgroundColor: UIColor.whiteColor

  style :scroll_view,
    showsVerticalScrollIndicator: false,
    showsHorizontalScrollIndicator: false,
    bounces: true,
    left: 70,
    top:  60,
    width: App.frame.size.width - 70,
    height: 44

  style :under_line_view,
    left: 0,
    top:  40,
    width: 70,
    height: 4,
    backgroundColor: UIColor.clearColor

  style :under_line_view_selected,
    backgroundColor: BW.rgb_color(0, 255, 255)  

  style :under_line_view_blured,
    backgroundColor: UIColor.clearColor

  style :button,
    height: 42,
    width: 50,
    top: 1,
    left: 0,
    title: 0xe6c7.chr(Encoding::UTF_8),
    font: UIFont.fontWithName("ionicons", size:20.0),
    titleColor: RN::Const::Color::DISABLE

  style :checked_button, extends: :button,
    titleColor: RN::Const::Color::CHECKED_BUTTON

  style :not_checked_button, extends: :button,
    titleColor: RN::Const::Color::NOT_CHECKED_BUTTON


end
