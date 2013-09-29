Teacup::Stylesheet.new :main_navigation_bar do
  style :base_view,
    backgroundColor: BW.rgba_color(90, 90, 90, 0.55),
    frame: CGRectMake( 0, 0, App.frame.size.width, 64)

  style :button,
    top: 28,
    height: 30,
    width: 30,
    font: FontAwesome.fontWithSize(24.0),
    titleColor: BW.rgb_color(0,255,255)

  style :settings_button, extends: :button,
    left: 5,
    title: FontAwesome.icon('cog')

  style :share_button, extends: :button,
    left: 74,
    title: FontAwesome.icon('share')

  style :channels_button, extends: :button,
    left: 143,
    title: FontAwesome.icon('rss')

  style :bookmarks_button, extends: :button,
    left: 212,
    title: FontAwesome.icon('bookmark')

  style :hide_menu_button, extends: :button,
    left: 281,
    title: FontAwesome.icon('resize-full')
end
