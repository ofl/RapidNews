class ChannelsModalView < UIView

  attr_accessor :delegate

  def initWithFrame(frame)
    super.tap do
      self.stylesheet = :channels_modal_view
      self.stylename = :base_view

      subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :cancel_button).tap do |b|
        b.setTitle("Cancel", forState:UIControlStateNormal)
        b.addTarget(self, action:"on_cancel_button_tapped", forControlEvents:UIControlEventTouchDown)
      end

      set_scroll_view
    end
  end

  def set_scroll_view
    channels = Channel.where(:is_checked).eq(true).order(:position).all
    width = 74 * channels.count + 16
    cf = CGRectMake( 0,  0, width, 100)
    img = UIImage.imageNamed("images/60x60.png")

    subview(UIScrollView.new, :scroll_view, {contentSize: cf.size, delegate: self}) do |s|
      subview UIView.new, {frame: cf}
      channels.each_with_index do |channel, i|
        left = 74 * i + 6
        button(:channel_button, { frame: CGRectMake(left, 21, 60, 60)}).tap do |b|
          if channel.image_url
            image = JMImageCache.sharedCache.imageForURL(NSURL.URLWithString(channel.image_url), delegate: self)
            b.setImage(image, forState: UIControlStateNormal)
            b.imageView.setContentMode(UIViewContentModeScaleAspectFill)
          else
            b.setImage(img, forState: UIControlStateNormal)
          end
          b.layer.cornerRadius = 10
          b.layer.setMasksToBounds(true)
          b.when(UIControlEventTouchUpInside) {
            p channel.id
            self.delegate.load_channel_articles(channel.id)
            self.delegate.dismiss_channel_view
          }
        end

        label_left = 74 * i + 4
        subview(UILabel.new, :channel_button_label).tap do |l|
          l.frame = CGRectMake(label_left, 84, 64, 10)
          l.text = channel.name
        end        
      end
    end
  end

  def on_cancel_button_tapped
    self.delegate.dismiss_channel_view
  end
end
