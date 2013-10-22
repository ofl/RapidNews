Teacup::Stylesheet.new :bookmarks_screen do
  style :button,
    height: 22,
    width: 22,
    top: 13,
    left: 8,
    font: FontAwesome.fontWithSize(20.0),
    titleColor: BW.rgb_color(200,200,200)

  style :checked_button, extends: :button,
    title: FontAwesome.icon('ok-sign'),
    titleColor: BW.rgb_color(0,150,255)

  style :nochecked_button, extends: :button,
    title: FontAwesome.icon('circle-blank'),
    titleColor: BW.rgb_color(200,200,200)
end
