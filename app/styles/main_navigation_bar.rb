Teacup::Stylesheet.new :main_navigation_bar do
  style :base_view,
    backgroundColor: BW.rgba_color(90, 90, 90, 0.55),
    frame: CGRectMake( 0, 0, App.frame.size.width, 64)

  style :badge,
    backgroundColor: BW.rgb_color(0, 255, 255),
    left: 23,
    top: 12,
    height: 16,
    width: 18,
    textAlignment: UITextAlignmentCenter,
    titleColor: BW.rgb_color(255,255,255)
end
