Teacup::Stylesheet.new :preview_screen do
  style :base_view,
    backgroundColor: BW.rgb_color(60, 60, 60)

  style :web_view,
    width: App.frame.size.width,
    top: 0,
    left: 0

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

  style :title_view,
    height: 40,
    width: App.frame.size.width - 100,
    top: 22,
    left: 50

  style :title_label,
    textAlignment: UITextAlignmentCenter,
    textColor: UIColor.whiteColor,
    font: UIFont.systemFontOfSize(14.0),
    height: 20,
    width: App.frame.size.width - 100,
    top: 2,
    left: 0

  style :url_label,
    textAlignment: UITextAlignmentCenter,
    textColor: BW.rgb_color(200,200,200),
    font: UIFont.systemFontOfSize(10.0),
    height: 15,
    width: App.frame.size.width - 100,
    top: 22,
    left: 0
end
