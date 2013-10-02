Teacup::Stylesheet.new :main_tool_bar do
  style :base_view,
    frame: [[0, '100% -90'], ['100%', 90]],
    backgroundColor: BW.rgba_color(90, 90, 90, 0.55)

  style :clear_toolbar,
    frame: [[0, 0], ['100%', 44]]

  style :slider,
    tag: 4,
    top: 48,
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
    textColor: BW.rgb_color(0,255,255),
    numberOfLines: 0,
    textAlignment: UITextAlignmentRight,
    font: UIFont.systemFontOfSize(15.0)

  style :segment_control,
    height: 20,
    width: 50,
    top: 53,
    left: 10
end
