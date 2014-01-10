Teacup::Stylesheet.new :home_article_view do
  style :white_base_view,
    backgroundColor: RN::Const::Color::WHITE_SUMMARY_BACK 
  style :black_base_view,
    backgroundColor: RN::Const::Color::BLACK_SUMMARY_BACK
  style :blwh_base_view,
    backgroundColor: RN::Const::Color::WHITE_SUMMARY_BACK
 
  style :title_background,
    height: 200,
    width: App.frame.size.width,
    top: 20,
    left: 0
 
  style :white_title_background, extends: :title_background,
    backgroundColor: RN::Const::Color::WHITE_TITLE_BACK
  style :black_title_background, extends: :title_background,
    backgroundColor: RN::Const::Color::BLACK_TITLE_BACK
  style :blwh_title_background, extends: :title_background,
    backgroundColor: RN::Const::Color::BLACK_TITLE_BACK

  style :title_label,
    verticalAlignment: VerticalAlignmentBottom,
    setLineBreakMode: UILineBreakModeWordWrap,
    backgroundColor: UIColor.clearColor,
    numberOfLines: 0,
    font: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline),
    height: 185,
    width: 300,
    top: 25,
    left: 10
 
  style :white_title_label, extends: :title_label,
    textColor: RN::Const::Color::WHITE_TITLE
  style :black_title_label, extends: :title_label,
    textColor: RN::Const::Color::BLACK_TITLE
  style :blwh_title_label, extends: :title_label,
    textColor: RN::Const::Color::BLACK_TITLE
 
  style :summary_label,
    verticalAlignment: VerticalAlignmentTop,
    setLineBreakMode: UILineBreakModeWordWrap,
    backgroundColor: UIColor.clearColor,
    numberOfLines: 0,
    font: UIFont.preferredFontForTextStyle(UIFontTextStyleBody),
    height: 270,
    width: 300,
    top: 230,
    left: 10
 
  style :white_summary_label, extends: :summary_label,
    textColor: RN::Const::Color::WHITE_SUMMARY
  style :black_summary_label, extends: :summary_label,
    textColor: RN::Const::Color::BLACK_SUMMARY
  style :blwh_summary_label, extends: :summary_label,
    textColor: RN::Const::Color::BLWH_SUMMARY

  style :image_view,
    height: 200,
    width: 320,
    top: 20,
    left: 0
 
  style :favicon_image_view,
    height: 15,
    width: 15,
    top: 177,
    left: 10
 
  style :info_label,
    height: 17,
    width: 280,
    top: 176,
    left: 30,
    backgroundColor: UIColor.clearColor,
    textColor: RN::Const::Color::WHITE_INFO,
    numberOfLines: 0

  style :white_info_label, extends: :info_label,
    textColor: RN::Const::Color::WHITE_INFO
  style :black_info_label, extends: :info_label,
    textColor: RN::Const::Color::BLACK_INFO
  style :blwh_info_label, extends: :info_label,
    textColor: RN::Const::Color::WHITE_INFO
end