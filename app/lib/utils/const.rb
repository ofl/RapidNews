module RapidNews
  module Const
    module Category
      SOCIAL = 0
      BUSINESS = 1
      ENTERTAINMENT = 2
      SPORTS = 3
      TECHNOLOGY = 4
      POLITICS = 5
      SCIENCE = 6
      WORLD = 7
    end

    module Country
      USA = 'us'
      UK = 'uk'
      JAPAN = 'jp'
    end

    module Design
      BLACK = 0
      WHITE = 1
    end

    module ArticlesSize
      SMALL = 0
      MEDIUM = 1
      LARGE = 2
    end

    module SwipeRight
      START = 0
      STOP = 1
      PREVIEW = 2
      BOOKMARK = 3
      SAFARI = 4
      CHROME = 5
      TWEET = 6
      FACEBOOK = 7
      POCKET = 8
      # INSTAPAPER = 9
      # READABILITY = 10
    end

    module SwipeLeft
      START = 0
      STOP = 1
      PREVIEW = 2
      BOOKMARK = 3
      SAFARI = 4
      CHROME = 5
      TWEET = 6
      FACEBOOK = 7
      POCKET = 8
      # INSTAPAPER = 9
      # READABILITY = 10
    end

    module BookmarkReader
      SAFARI = 0
      EMAIL = 1
      POCKET = 2
      INSTAPAPER = 3
      READABILITY = 4
    end

    module ShareService
      HATENA = 0
      POCKET = 1
      INSTAPAPER = 2
      READABILITY = 3
    end

    module EmailField
      SUBJECT = 1
      TO = 2
      CC = 3
      BCC = 4
    end

    module SlideShow
      MAX_INTERVAL = 30.0
      MIN_INTERVAL = 0.3
    end
  end

  module Titles
    CATEGORY = {
      Const::Category::SOCIAL => 'social',
      Const::Category::BUSINESS => 'business',
      Const::Category::ENTERTAINMENT => 'ent',
      Const::Category::SPORTS => 'sports',
      Const::Category::TECHNOLOGY => 'tech',
      Const::Category::POLITICS => 'politics',
      Const::Category::SCIENCE => 'sience',
      Const::Category::WORLD => 'world'
    }

    COUNTRY = {
      Const::Country::USA => 'usa',
      Const::Country::UK => 'uk',
      Const::Country::JAPAN => 'japan',
    }

    ARTICLES_SIZE = {
      Const::ArticlesSize::SMALL       => "20",
      Const::ArticlesSize::MEDIUM      => "500",
      Const::ArticlesSize::LARGE       => "1000",
    }

    DESIGN = {
      Const::Design::BLACK      => 'black',
      Const::Design::WHITE      => 'white',
    }

    SWIPE_RIGHT = {
      Const::SwipeRight::START       => 'start',
      Const::SwipeRight::STOP        => 'stop',
      Const::SwipeRight::PREVIEW     => 'preview',
      Const::SwipeRight::BOOKMARK    => 'bookmark',
      Const::SwipeRight::SAFARI      => 'safari',
      Const::SwipeRight::CHROME      => 'chrome',
      Const::SwipeRight::TWEET       => 'tweet',
      Const::SwipeRight::FACEBOOK    => 'facebook',
      Const::SwipeRight::POCKET      => 'pocket',
      # Const::SwipeRight::INSTAPAPER  => 'instapaper',
      # Const::SwipeRight::READABILITY => 'readability',
    }

    SWIPE_LEFT = {
      Const::SwipeLeft::START       => 'start',
      Const::SwipeLeft::STOP        => 'stop',
      Const::SwipeLeft::PREVIEW     => 'preview',
      Const::SwipeLeft::BOOKMARK    => 'bookmark',
      Const::SwipeLeft::SAFARI      => 'safari',
      Const::SwipeLeft::CHROME      => 'chrome',
      Const::SwipeLeft::TWEET       => 'tweet',
      Const::SwipeLeft::FACEBOOK    => 'facebook',
      Const::SwipeLeft::POCKET      => 'pocket',
      # Const::SwipeLeft::INSTAPAPER  => 'instapaper',
      # Const::SwipeLeft::READABILITY => 'readability',
    }

    BOOKMARK_READER = {
      Const::BookmarkReader::SAFARI      => 'safari',
      Const::BookmarkReader::EMAIL       => 'email',
      Const::BookmarkReader::POCKET      => 'pocket',
      # Const::BookmarkReader::INSTAPAPER  => 'instapaper',
      # Const::BookmarkReader::READABILITY => 'readability',
    }

    SHARE_SERVICE = {
      Const::ShareService::HATENA      => 'hatena',
      Const::ShareService::POCKET      => 'pocket',
      Const::ShareService::INSTAPAPER  => 'instapaper',
      Const::ShareService::READABILITY => 'readability',
    }

    EMAIL_FIELD = {
      Const::EmailField::SUBJECT     => 'email_subject',
      Const::EmailField::TO          => 'email_to',
      Const::EmailField::CC          => 'email_cc',
      Const::EmailField::BCC         => 'email_bcc',
    }
  end

  module Images
    BOOKMARK_READER = {
      Const::BookmarkReader::EMAIL       => 'images/021-Email.png',
      Const::BookmarkReader::POCKET      => 'images/NNPocketActivity_toolbar.png',
      Const::BookmarkReader::INSTAPAPER  => 'images/instapaper_toolbar.png',
      Const::BookmarkReader::READABILITY => 'images/NNReadabilityActivity_toolbar.png',
      Const::BookmarkReader::SAFARI      => 'images/Safari_toolbar.png',
    }
  end
end
