    Teacup::Stylesheet.new :home_article_view do
  style :base_view,
    backgroundColor: BW.rgb_color(60, 60, 60)
 
  style :title_background,
    backgroundColor: BW.rgb_color(50, 50, 50),
    height: 200,
    width: App.frame.size.width,
    top: 0,
    left: 0
 
  style :title_label,
    verticalAlignment: VerticalAlignmentBottom,
    backgroundColor: UIColor.clearColor,
    text: "Welcome to RapidNews!",
    textColor: UIColor.whiteColor,
    numberOfLines: 3,
    font: UIFont.systemFontOfSize(17.0),
    height: 105,
    width: 213,
    top: 65,
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
    top: 210,
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
    top: 110,
    left: 230
 
  style :favicon_image_view,
    height: 15,
    width: 15,
    top: 177,
    left: 10
 
  style :host_label,
    height: 17,
    width: 180,
    top: 176,
    left: 30,
    backgroundColor: UIColor.clearColor,
    textColor: BW.rgb_color(200, 200, 200),
    numberOfLines: 0,
    font: UIFont.italicSystemFontOfSize(12.0)
end