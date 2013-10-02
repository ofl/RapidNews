Teacup::Stylesheet.new :main_tool_bar do
  style :base_view,
    frame: [[0, '100% -100'], ['100%', 100]],
    backgroundColor: BW.rgba_color(90, 90, 90, 0.55)

  style :start_button,
    top: 17,
    left: 140,
    height: 40,
    width: 40,
    title: FontAwesome.icon('play'),
    font: FontAwesome.fontWithSize(35.0),
    titleColor: BW.rgb_color(0,255,255)

  style :paused_button,
    title: FontAwesome.icon('play')

  style :playing_button,
    title: FontAwesome.icon('pause')

  style :reset_button,
    titleColor: BW.rgb_color(0,255,255),
    userInteractionEnabled: true

  style :disable_button,
    titleColor: BW.rgb_color(60,60,60),
    userInteractionEnabled: false

  style :action_button,
    top: 17,
    left: 240,
    height: 30,
    width: 30

  style :slider,
    tag: 4,
    top: 60,
    left: 10,
    height: 15,
    width: 300,
    minimumValue: 1.0,
    maximumValue: 200.0,
    value: 1.0,
    alpha: 0.5,
    userInteractionEnabled: false

  style :counter_label,
    height: 20,
    width: 50,
    top: 5,
    left: 260,
    backgroundColor: UIColor.clearColor,
    text: "0/0",
    textColor: BW.rgb_color(0,255,255),
    numberOfLines: 0,
    textAlignment: UITextAlignmentRight,
    font: UIFont.systemFontOfSize(15.0)
end
