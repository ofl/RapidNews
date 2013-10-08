Teacup::Stylesheet.new :preview_screen do
  style :base_view,
    backgroundColor: BW.rgb_color(255, 255, 255)

  style :webview,
    backgroundColor: BW.rgb_color(255, 255, 255)

  style :nav_bar,
    barStyle: UIBarStyleBlack,
    frame: CGRectMake( 0,  0, App.frame.size.width, 64)

  style :button,
    top: 28,
    height: 30,
    width: 30,
    font: FontAwesome.fontWithSize(24.0),
    titleColor: UIColor.whiteColor

  style :back_button, extends: :button,
    tag: 1,
    left: 5,
    title: FontAwesome.icon('arrow-left')

  style :share_button, extends: :button,
    tag: 3,
    left: 143,
    title: FontAwesome.icon('share')

  style :bookmark_button, extends: :button,
    tag: 4,
    left: 212,
    title: FontAwesome.icon('bookmark')

  style :refresh_button, extends: :button,
    tag: 5,
    left: 281,
    title: FontAwesome.icon('refresh')
end
