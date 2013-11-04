class NewsSource
  
  include MotionModel::Model
  include MotionModel::ArrayModelAdapter
  include RapidNews::Model

  columns :name        => :string,
    :category    => :int,
    :country     => :string,
    :cc          => :int,
    :url         => :string,
    :host        => :string,
    :fetched_at  => :date,
    :image_path  => :string,
    :channels    => :array

  def crawl_articles
    article_manager = ArticleManager.instance
    article_manager.crawl(self)
    self.fetched_at = Time.now
    self.save
    self.class.save_to_file
  end
end
