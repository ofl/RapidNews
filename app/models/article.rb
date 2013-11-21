class Article

  include MotionModel::Model
  include MotionModel::ArrayModelAdapter
  include RapidNews::Model

  columns :title        => :string,
          :summary      => :string,
          :link_url     => :string,
          :host         => :string,
          :image_url    => :string,
          :pub_at       => :string,
          :is_bookmarked => :bool,
          :created_at   => :date

  attr_accessor :is_checked

  class << self
    def build(source, item)
      self.new({
        link_url:      item[:link][:text],
        title:         item[:title][:text],
        pub_at:        item[:pubDate][:text],
        summary:       item[:description][:text].split('<')[0],
        link_url:      item[:link][:text],
        host:          source.host,
        is_checked:    true,
        is_bookmarked: false,
        image_url:     search_image_url(item, source.image_path),
      })
    end

    def search_image_url(item, path)
      return nil unless path
      result = item.valueForKeyPath(path)
      return nil unless result
      if result.is_a?(Array)
        return result[0]
      elsif result.is_a?(String)
        return result
      end
      nil
    end

    def bookmarks
      self.where(:is_bookmarked).eq(true).order{ |one, two| two.id <=> one.id }.all
    end
  end

  # https://gist.github.com/is8r/5855992
  def since_post
    date = NSDate.dateWithNaturalLanguageString(self.pub_at)
    now = NSDate.dateWithTimeIntervalSinceNow(NSTimeZone.systemTimeZone.secondsFromGMT)
    since = now.timeIntervalSinceDate(date)
    day = (since/(24*60*60)).floor
    hour = (since/(60*60)).floor
    minutes = ((since/60)%60).to_i
    if hour == 0
      return "#{minutes}m ago"
    elsif day == 0
      return "#{hour}h ago"
    else
      return "#{day}d ago"
    end
  end
end