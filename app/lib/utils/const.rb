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
      Const::Category::SOCIAL => BW::localized_string(:social, "Social"),
      Const::Category::BUSINESS => BW::localized_string(:business, "Business"),
      Const::Category::ENTERTAINMENT => BW::localized_string(:ent, "Ent"),
      Const::Category::SPORTS => BW::localized_string(:sports, "Sports"),
      Const::Category::TECHNOLOGY => BW::localized_string(:tech, "Tech"),
      Const::Category::POLITICS => BW::localized_string(:politics, "Politics"),
      Const::Category::SCIENCE => BW::localized_string(:sience, "Sience"),
      Const::Category::WORLD => BW::localized_string(:world, "World")
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
      Const::Appearence::BLWH       => BW::localized_string(:blwh, 'Black + White'),
      Const::Appearence::BLACK      => BW::localized_string(:black, 'Black'),
      Const::Appearence::WHITE      => BW::localized_string(:white, 'White'),
    }

    SWIPE_RIGHT = {
      Const::SwipeRight::START       => BW::localized_string(:start, 'Start slideshow'),
      Const::SwipeRight::STOP        => BW::localized_string(:stop, "Stop slideshow"),
      Const::SwipeRight::PREVIEW     => BW::localized_string(:preview, "Preview"),
      Const::SwipeRight::BOOKMARK    => BW::localized_string(:add_bookmark, "Add to bookmarks"),
      Const::SwipeRight::SAFARI      => BW::localized_string(:open_safari, "Open URL in Safari"),
      Const::SwipeRight::CHROME      => BW::localized_string(:open_chrome, "Open URL in Chrome"),
      Const::SwipeRight::TWEET       => BW::localized_string(:post_tweet, "Tweet"),
      Const::SwipeRight::FACEBOOK    => BW::localized_string(:post_facebook, "Post on Facebook wall"),
      Const::SwipeRight::POCKET      => BW::localized_string(:send_pocket, "Send to Pocket"),
      # Const::SwipeRight::INSTAPAPER  => BW::localized_string(:send_instapaper, "Send to Instapaper"),
      # Const::SwipeRight::READABILITY => BW::localized_string(:send_readability, "Send to Readability"),
    }

    SWIPE_LEFT = {
      Const::SwipeLeft::START       => BW::localized_string(:start, 'Start slideshow'),
      Const::SwipeLeft::STOP        => BW::localized_string(:stop, "Stop slideshow"),
      Const::SwipeLeft::PREVIEW     => BW::localized_string(:preview, "Preview"),
      Const::SwipeLeft::BOOKMARK    => BW::localized_string(:add_bookmark, "Add to bookmarks"),
      Const::SwipeLeft::SAFARI      => BW::localized_string(:open_safari, "Open URL in Safari"),
      Const::SwipeLeft::CHROME      => BW::localized_string(:open_chrome, "Open URL in Chrome"),
      Const::SwipeLeft::TWEET       => BW::localized_string(:post_tweet, "Tweet"),
      Const::SwipeLeft::FACEBOOK    => BW::localized_string(:post_facebook, "Post on Facebook wall"),
      Const::SwipeLeft::POCKET      => BW::localized_string(:send_pocket, "Send to Pocket"),
      # Const::SwipeLeft::INSTAPAPER  => BW::localized_string(:send_instapaper, "Send to Instapaper"),
      # Const::SwipeLeft::READABILITY => BW::localized_string(:send_readability, "Send to Readability"),
    }

    BOOKMARK_READER = {
      Const::BookmarkReader::SAFARI      => BW::localized_string(:safari, 'safari'),
      Const::BookmarkReader::EMAIL       => BW::localized_string(:email, 'email'),
      Const::BookmarkReader::POCKET      => BW::localized_string(:pocket, 'pocket'),
      # Const::BookmarkReader::INSTAPAPER  => BW::localized_string(:instapaper, 'instapaper'),
      # Const::BookmarkReader::READABILITY => BW::localized_string(:readability, 'readability'),
    }

    SHARE_SERVICE = {
      Const::ShareService::HATENA      => BW::localized_string(:hatena, 'Hatena'),
      Const::ShareService::POCKET      => BW::localized_string(:pocket, 'Pocket'),
      # Const::ShareService::INSTAPAPER  => BW::localized_string(:instapaper, 'Instapaper'),
      # Const::ShareService::READABILITY => BW::localized_string(:readability, 'Readability'),
    }

    EMAIL_FIELD = {
      Const::EmailField::SUBJECT     => BW::localized_string(:email_subject, 'Subject'),
      Const::EmailField::TO          => BW::localized_string(:email_to, 'To'),
      Const::EmailField::CC          => BW::localized_string(:email_cc, 'Cc'),
      Const::EmailField::BCC         => BW::localized_string(:email_bcc, 'Bcc'),
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
