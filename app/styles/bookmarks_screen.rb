Teacup::Stylesheet.new :bookmarks_screen do
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
