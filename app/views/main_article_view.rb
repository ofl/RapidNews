class MainArticleView < UIView

  attr_accessor :index

  def initWithFrame(frame)
    @index = 0
    super.tap do
      self.stylesheet = :main_article_view
      self.stylename = :base_view
      subview UIView, :title_background
      @default_image = UIImage.imageNamed('images/77x50.png')
      @image_view = subview UIImageView.alloc.initWithImage(@default_image), :image_view
      @title_label = subview VerticallyAlignedLabel.new, :title_label
      @summary_label = subview VerticallyAlignedLabel.new, :summary_label
    end
  end

  def update_article(article)
    @title_label.text = article.title
    @summary_label.text = article.summary

    if article.image_url
      @image_view.setImageWithURLRequest( NSURLRequest.alloc.initWithURL(NSURL.URLWithString(article.image_url)),
                                          placeholderImage: @default_image,
                                          success: -> (req, res, image) { @image_view.image = image },
                                          failure: -> (req, res, error) { @image_view.image = @default_image })
    else
      @image_view.image = @default_image
    end
  end

  def fade_in
  end

  def fade_out
  end
end
