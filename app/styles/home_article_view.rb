Teacup::Stylesheet.new :home_article_view do
  style :base_view,
    backgroundColor: BW.rgb_color(60, 60, 60)
 
  style :title_background,
    backgroundColor: BW.rgb_color(30, 30, 30),
    height: 160,
    width: App.frame.size.width,
    top: 0,
    left: 0
 
  style :title_label,
    verticalAlignment: VerticalAlignmentBottom,
    backgroundColor: UIColor.clearColor,
    text: "Welcome to RapidNews!",
    textColor: UIColor.whiteColor,
    numberOfLines: 3,
    font: UIFont.boldSystemFontOfSize(15.0),
    height: 95,
    width: 213,
    top: 55,
    left: 10
 
  style :summary_label,
    verticalAlignment: VerticalAlignmentTop,
    backgroundColor: UIColor.clearColor,
    text: "Welcome to RapidNews!",
    textColor: UIColor.whiteColor,
    numberOfLines: 0,
    font: UIFont.systemFontOfSize(17.0),
    height: 220,
    width: 300,
    top: 170,
    left: 10
 
  style :date_label,
    backgroundColor: UIColor.clearColor,
    text: "Welcome to RapidNews!",
    textColor: UIColor.blackColor,
    numberOfLines: 0,
    textAlignment: UITextAlignmentCenter,
    font: UIFont.boldSystemFontOfSize(18.0)
 
  style :source_label,
    backgroundColor: UIColor.clearColor,
    text: "Welcome to RapidNews!",
    textColor: UIColor.whiteColor,
    shadowColor: UIColor.blackColor,
    numberOfLines: 0,
    textAlignment: UITextAlignmentCenter,
    font: UIFont.boldSystemFontOfSize(18.0)
 
  style :image_view,
    height: 90,
    width: 90,
    top: 0,
    left: 230
end