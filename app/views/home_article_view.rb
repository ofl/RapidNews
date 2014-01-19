class HomeArticleView < UIView

  attr_accessor :index

  def initWithFrame(frame)
    super.tap do
      @article_manager = ArticleManager.instance
      appearence = ['blwh', 'black', 'white'][App::Persistence['appearence']]
      self.stylesheet = :home_article_view

      self.stylename = "#{appearence}_base_view".to_sym
      @info_label = subview UILabel.new, "#{appearence}_info_label".to_sym
      @title_background = subview UIView, "#{appearence}_title_background".to_sym
      @image_view = subview UIImageView.alloc.init, :image_view
      @title_label = subview VerticallyAlignedLabel.new, "#{appearence}_title_label".to_sym
      @summary_label = subview VerticallyAlignedLabel.new, "#{appearence}_summary_label".to_sym
      @favicon_image_view = subview UIImageView.alloc.init, :favicon_image_view
      @info_label.font = italic_font
    end
  end

  def update_image_view(image_url)
    @image_view.contentMode = UIViewContentModeScaleAspectFill
    @image_view.hidden = false
    @image_view.setImageWithURL(image_url, 
                                placeholderImage: UIImage.imageNamed("images/77x50.png"))
    gradient = CAGradientLayer.layer
    gradient.frame = @image_view.bounds
    gradient.colors = [BW.rgba_color(0,0,0, 1.0).CGColor, BW.rgba_color(0,0,0, 0.3).CGColor]
    @image_view.layer.mask = gradient
  end

  def italic_font
    fontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleCaption1)
    italicFontDescriptor = fontDescriptor.fontDescriptorWithSymbolicTraits(UIFontDescriptorTraitItalic)
    UIFont.fontWithDescriptor(italicFontDescriptor, size:0.0)
  end

  def update_article(index)
    @index ||= index
    article = @article_manager.find_article_by_index(@index)
    return unless article

    @title_label.text = article.title
    @summary_label.text = article.summary
    @summary_label.sizeToFit
    @info_label.text = "#{article.host} #{article.since_post}"

    if App::Persistence['show_picture'] && article.image_url && @article_manager.can_load_image
      update_image_view(article.image_url)
    else
      @image_view.hidden = true
    end

    @favicon_image_view.setImageWithURL("http://www.google.com/s2/favicons?domain=#{article.host}", 
                                        placeholderImage: UIImage.imageNamed("images/000000.png"))
    top = @summary_label.frame.size.height + 240
    @info_label.frame = [[30, top - 3], [280, 17]]
    @favicon_image_view.frame = [[10, top], [15, 15]]
  end

  def update_style
    appearence = ['blwh', 'black', 'white'][App::Persistence['appearence']]
    self.stylename = "#{appearence}_base_view".to_sym
    @info_label.stylename = "#{appearence}_info_label".to_sym
    @title_background.stylename = "#{appearence}_title_background".to_sym
    @title_label.stylename = "#{appearence}_title_label".to_sym
    @summary_label.stylename = "#{appearence}_summary_label".to_sym
  end
end
