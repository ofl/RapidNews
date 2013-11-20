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
    def create_unique_article(source, item)
      # for atom info item
      return nil if item['rel'] == 'self' 

      # for .eq(item[:link][:text]) not found bug
      article = self.new({:link_url => item[:link][:text]})
      return nil if self.where(:link_url).eq(article.link_url).count > 0

      article.title         = item[:title][:text]
      article.pub_at        = item[:pubDate][:text]
      article.summary       = item[:description][:text].split('<')[0]
      article.link_url      = item[:link][:text]
      article.host          = source.host
      article.is_checked    = true
      article.is_bookmarked = false
      article.image_url     = search_image_url(item, source.image_path)
      article.save
      article
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