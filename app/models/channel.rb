class Channel

  include MotionModel::Model
  include MotionModel::ArrayModelAdapter
  include RapidNews::Model

  columns :name      => :string,
    :is_checked    => :bool,
    :position  => :int

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

  def news_sources
    @collection = NewsSource.where(:channels).ne(nil).all
    @collection = @collection.collect do |item|
      item if item.channels.include?(self.id)
    end.compact
  end

  def regist(news_source)
    array = news_source.channels ? news_source.channels : []
    unless array.include?(self.id)
      array.push self.id      
    end
    news_source.channels = array
    news_source.save
    NewsSource.save_to_file
  end

  def unregist(news_source)
    array = news_source.channels ? news_source.channels : []
    array.delete self.id
    news_source.channels = array
    news_source.save
    NewsSource.save_to_file
  end
end