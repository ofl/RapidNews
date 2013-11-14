class NewsSource
  
  include MotionModel::Model
  include MotionModel::ArrayModelAdapter
  include MotionModel::Validatable
  include RapidNews::Model

  columns :name        => :string,
    :category    => {:type => :int, :default => 1},
    :country     => {:type => :string, :default => 'ja'},
    :url         => :string,
    :host        => :string,
    :fetched_at  => :date,
    :image_path  => :string,
    :channels    => :array

  validate :name, :length => 1..50
  validate :url, :length => 1..2083

  def crawl_articles
    article_manager = ArticleManager.instance
    article_manager.crawl(self)
    self.fetched_at = Time.now
    self.save
    self.class.save_to_file
  end

  def before_save(sender)
    p 99999
    true
    # return false if sender.find(:privilege_level).eq('admin').count < 2
  end
end
