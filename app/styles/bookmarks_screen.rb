Teacup::Stylesheet.new :bookmarks_screen do
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
