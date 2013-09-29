Teacup::Stylesheet.new :main_screen do
  style :base_view,
    backgroundColor: BW.rgb_color(60, 60, 60)
 
  style :bookmarked_button,
    tag: 6,
    top: 147,
    left: 0,
    height: 35,
    width: 35,
    title: FontAwesome.icon('star'),
    font: FontAwesome.fontWithSize(30.0),
    titleColor: BW.rgb_color(140,140,140)
 
  style :is_bookmarked,
    titleColor: BW.rgb_color(255,255,255)
 
  style :is_not_bookmarked,
    titleColor: BW.rgb_color(140,140,140)
 
  style :preview_button,
    tag: 6,
    top: 147,
    left: 285,
    height: 35,
    width: 35,
    title: FontAwesome.icon('chevron-right'),
    font: FontAwesome.fontWithSize(30.0),
    titleColor: BW.rgb_color(140,140,140)
 
  style :counter_label,
    height: 20,
    width: 50,
    top: 5,
    left: 260,
    backgroundColor: UIColor.clearColor,
    text: "0/0",
    textColor: BW.rgb_color(200,200,200),
    numberOfLines: 0,
    textAlignment: UITextAlignmentRight,
    font: UIFont.systemFontOfSize(17.0)      
end