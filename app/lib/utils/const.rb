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

    module Appearence
      BLWH = 0
      BLACK = 1
      WHITE = 2
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

    module Color
      TINT = BW.rgb_color(0, 255, 255)
      DARK_TINT = BW.rgb_color(0, 180, 180)
      BAR_TINT = BW.rgba_color(0, 0, 0, 0.70)
      DARK_BAR_TINT = BW.rgba_color(90, 90, 90, 0.55)
      HOME_SCREEN = BW.rgb_color(60, 60, 60)
      TITLE = BW.rgb_color(40, 40, 40)
      DETAIL = BW.rgb_color(120, 120, 120)
      DISABLE = BW.rgb_color(200, 200, 200)
      EDITABLE = BW.rgb_color(0, 0, 255)
      DANGER = BW.rgb_color(255, 0, 0)
      CAUTION = BW.rgb_color(255, 255, 0)
      SAFE = BW.rgb_color(0, 255, 0)

      HOME_TOOL_BAR = BW.rgba_color(150, 150, 150, 0.30)
      HOME_TOOL_BAR_TRANSPARENT = BW.rgba_color(60, 60, 60, 0)
      DARK_HOME_TOOL_BAR_TRANSPARENT = BW.rgba_color(60, 60, 60, 0)
      CHECKED_BUTTON = BW.rgb_color(0,150,255)
      NOT_CHECKED_BUTTON = BW.rgb_color(230, 230, 230)
      CHANNEL_MODAL_TOOLBAR = BW.rgba_color(255, 255, 255, 0.80)

      BLACK_TITLE = UIColor.whiteColor
      BLACK_TITLE_BACK = BW.rgb_color(40, 40, 40)
      BLACK_SUMMARY = BW.rgb_color(225, 225, 225)
      BLACK_SUMMARY_BACK = BW.rgb_color(50, 50, 50)
      BLACK_INFO = BW.rgb_color(200, 200, 200)
      WHITE_TITLE = BW.rgb_color(40, 40, 40)
      WHITE_TITLE_BACK = BW.rgb_color(235, 235, 235)
      WHITE_SUMMARY = BW.rgb_color(50, 50, 50)
      WHITE_SUMMARY_BACK = BW.rgb_color(225, 225, 225)
      WHITE_INFO = BW.rgb_color(150, 150, 150)
      BLWH_SUMMARY = BW.rgb_color(70, 70, 70)
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

    APPEARENCE = {
      Const::Appearence::BLWH      => 'blwh',
      Const::Appearence::BLACK      => 'black',
      Const::Appearence::WHITE      => 'white',
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
      # Const::ShareService::INSTAPAPER  => 'instapaper',
      # Const::ShareService::READABILITY => 'readability',
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
