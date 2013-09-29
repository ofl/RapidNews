module Teacup::Layout
  def button(*args, &block)
    # apply a default stylename
    args = [:button] if args.empty?

    # instantiate a button and give it a style class
    subview(UIButton.buttonWithType(UIButtonTypeCustom), *args, &block)
  end

  def button_with_icon(icon, title)
    label = UILabel.new
    label.text = title
    label.sizeToFit

    image_view = UIImageView.new
    image_view.image = icon
    image_view.sizeToFit

    button = UIButton.buttonWithType(UIButtonTypeCustom)
    button.addSubview(image_view)
    button.addSubview(label)

    # code could go here to position the icon and label, or at could be handled
    # by the stylesheet

    subview(button)
  end
end