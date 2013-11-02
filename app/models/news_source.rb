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
    :position    => :int,
    :fetched_at  => :date,
    :image_path  => :string,
    :channels    => :array

  def company
    Company.where(:cc).eq(self.cc).first
  end

  def crawl_articles
    article_manager = ArticleManager.instance
    article_manager.crawl(self)
    self.fetched_at = Time.now
    self.save
    self.class.save_to_file
  end

  def move_position_to(old_pos, new_pos)
    if new_pos > old_pos
      objects = self.class.find{ |o| o.channel_id == self.channel_id && o.position > old_pos && o.position <= new_pos }
      p objects.count
      objects.each do |o|
        o.position -= 1
        o.save
      end
    else
      objects = self.class.find{ |o| o.channel_id == self.channel_id && o.position < old_pos && o.position >= new_pos }
      p objects.count
      objects.each do |o|
        o.position += 1
        o.save
      end
    end
    self.position = new_pos
    self.save()
    self.class.save_to_file
  end
end
