Teacup::Stylesheet.new :bookmarks_screen do
  style :button,
    height: 42,
    width: 38,
    top: 1,
    left: 0,
    title: FontAwesome.icon('ok-sign'),
    font: FontAwesome.fontWithSize(20.0),
    titleColor: BW.rgb_color(200,200,200)

  style :checked_button, extends: :button,
    titleColor: BW.rgb_color(0,150,255)

  style :nochecked_button, extends: :button,
    titleColor: BW.rgb_color(230,230,230)
end
