class Article

  include MotionModel::Model
  include MotionModel::ArrayModelAdapter
  include RapidNews::Model

  columns :title        => :string,
          :summary      => :string,
          :cc           => :int,
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

      article.cc            = source.cc
      article.title         = item[:title][:text]
      article.pub_at        = item[:pubDate][:text]
      article.summary       = item[:description][:text].split('<')[0]
      article.link_url      = item[:link][:text]
      article.host          = source.host
      article.is_checked    = false
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

  def company
    NewsCompany.where(:cc).eq(self.cc).first
  end  
end