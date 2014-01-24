Teacup::Stylesheet.new :home_screen do
  style :base_view,
    backgroundColor: RN::Const::Color::HOME_SCREEN

  style :counter_label,
    height: 20,
    width: 50,
    top: 20,
    left: 260,
    backgroundColor: UIColor.clearColor,
    text: "0/0",
    textColor: UIColor.whiteColor,
    numberOfLines: 0,
    textAlignment: UITextAlignmentRight,
    font: UIFont.systemFontOfSize(13.0)

  style :white_counter_label, extends: :counter_label,
    textColor: RN::Const::Color::WHITE_INFO
  style :black_counter_label, extends: :counter_label,
    textColor: RN::Const::Color::BLACK_INFO
  style :blwh_counter_label, extends: :counter_label,
    textColor: RN::Const::Color::WHITE_INFO
 end