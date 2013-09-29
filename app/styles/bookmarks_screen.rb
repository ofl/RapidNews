Teacup::Stylesheet.new :bookmarks_screen do
  style :button,
    height: 22,
    width: 22,
    top: 13,
    left: 8,
    font: FontAwesome.fontWithSize(20.0),
    titleColor: BW.rgb_color(140,140,140)

  style :checked_button, extends: :button,
    title: FontAwesome.icon('check')

  style :nochecked_button, extends: :button,
    title: FontAwesome.icon('check-empty')
end
