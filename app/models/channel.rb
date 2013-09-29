class Channel

  include MotionModel::Model
  include MotionModel::ArrayModelAdapter
  include RapidNews::Model
  
  columns :name      => :string,
    :is_checked    => :bool,
    :position  => :int

  has_many    :news_sources

  def move_position_to(old_pos, new_pos)
    if new_pos > old_pos
      objects = self.class.find{ |o| o.position > old_pos && o.position <= new_pos }
      objects.each do |o|
        o.position -= 1
        o.save
      end
    else
      objects = self.class.find{ |o| o.position < old_pos && o.position >= new_pos }
      objects.each do |o|
        o.position += 1
        o.save
      end
    end
    self.position = new_pos
    self.save()
    self.class.save_to_file
  end

  def regist(news_source)
    news_source.position = self.news_sources.count
    news_source.channel = self
    news_source.save
    NewsSource.save_to_file
  end

  def unregist(news_source)
    news_sources = NewsSource.find{|o| o.channel_id == self.id && o.position > news_source.position}
    news_sources.each do |o|
      o.position -= 1
      o.save
    end
    news_source.channel = nil
    news_source.save
    NewsSource.save_to_file
  end
end
