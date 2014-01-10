Teacup::Stylesheet.new :home_navigation_bar do
  style :base_view,
    backgroundColor: RN::Const::Color::BAR_TINT,
    frame: CGRectMake( 0, 0, App.frame.size.width, 64)

  style :badge,
    backgroundColor: RN::Const::Color::TINT,
    left: 23,
    top: 12,
    height: 16,
    width: 18,
    textAlignment: UITextAlignmentCenter,
    titleColor: UIColor.whiteColor
end
