class HomeArticleView < UIView

  attr_accessor :index

  def initWithFrame(frame)
    @index = 0
    super.tap do
      self.stylesheet = :home_article_view
      self.stylename = :base_view
      subview UIView, :title_background

      @article_manager = ArticleManager.instance
      @default_image = UIImage.imageNamed('images/77x50.png')
      @image_view = subview UIImageView.alloc.initWithImage(@default_image), :image_view
      @title_label = subview VerticallyAlignedLabel.new, :title_label
      @summary_label = subview VerticallyAlignedLabel.new, :summary_label
      @favicon_image_view = subview UIImageView.alloc.initWithImage(@default_image), :favicon_image_view
      @host_label = subview UILabel.new, :host_label
      @host_label.font = italic_font
    end
  end

  def update_image_view(image_url)
    @image_view.hidden = false
    @image_view.setImageWithURL(image_url, placeholderImage:nil, options:SDWebImageCacheMemoryOnly)
  end

  def italic_font
    fontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleCaption1)
    italicFontDescriptor = fontDescriptor.fontDescriptorWithSymbolicTraits(UIFontDescriptorTraitItalic)
    UIFont.fontWithDescriptor(italicFontDescriptor, size:0.0)
  end

  def update_article(index)
    article = @article_manager.find_article_by_index(index)
    return unless article

    @index = index
    @title_label.text = article.title
    @summary_label.text = article.summary

    if !article.image_url
      @image_view.hidden = true
    elsif @article_manager.can_load_image
        update_image_view(article.image_url)
    else
      @image_view.hidden = true
    end

    url = NSURL.URLWithString("http://www.google.com/s2/favicons?domain=#{article.host}")
    data = NSData.dataWithContentsOfURL(url)
    remote = UIImage.imageWithData(data)
    @favicon_image_view.image = remote
    @host_label.text = "#{article.host} #{article.since_post}"
  end

  def fade_in
  end

  def fade_out
  end
end
