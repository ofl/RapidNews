Teacup::Stylesheet.new :home_tool_bar do
  style :base_view,
    frame: [[0, '100% -90'], ['100%', 90]],
    # translucent: true,
    backgroundColor: RN::Const::Color::BAR_TINT

  style :clear_toolbar,
    frame: [[0, 0], ['100%', 44]]

  style :slider,
    tag: 4,
    top: 57,
    left: 75,
    height: 15,
    width: 180,
    minimumValue: 1.0,
    maximumValue: 200.0,
    value: 1.0,
    alpha: 0.5,
    userInteractionEnabled: false

  style :counter_label,
    height: 20,
    width: 50,
    top: 53,
    left: 260,
    backgroundColor: UIColor.clearColor,
    text: "0/0",
    textColor: RN::Const::Color::TINT,
    numberOfLines: 0,
    textAlignment: UITextAlignmentRight,
    font: UIFont.systemFontOfSize(13.0)

  style :segmented_control,
    height: 26,
    width: 54,
    top: 51,
    left: 8,
    momentary: true
end
