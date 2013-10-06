module RapidNews
  module Const
    module Speed
      FIXED = 0
      VARIABLE = 1
    end

    module Accelerate
      YES = 0
      NO = 1
    end

    module Design
      BLACK = 0
      WHITE = 1
    end

    module FontSize
      SMALL = 0
      MEDIUM = 1
      LARGE = 2
    end

    module ArticlesSize
      SMALL = 0
      MEDIUM = 1
      LARGE = 2
    end

    module SwipeAction
      START = 0
      STOP = 1
      PREVIEW = 2
      BOOKMARK = 3
      SAFARI = 4
      CHROME = 5
      TWEET = 6
      FACEBOOK = 7
      POCKET = 8
      INSTAPAPER = 9
      READABILITY = 10
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
    ARTICLES_SIZE = {
      # Const::ArticlesSize::SMALL       => "250",
      Const::ArticlesSize::SMALL       => "20",
      Const::ArticlesSize::MEDIUM      => "500",
      Const::ArticlesSize::LARGE       => "1000",
    }

    SPEED = {
      Const::Speed::FIXED       => 'fixed',
      Const::Speed::VARIABLE    => 'variable',
    }

    ACCELERATE = {
      Const::Accelerate::YES    => 'yes',
      Const::Accelerate::NO     => 'no',
    }

    DESIGN = {
      Const::Design::BLACK      => 'black',
      Const::Design::WHITE      => 'white',
    }

    FONT_SIZE = {
      Const::FontSize::SMALL    => 'small',
      Const::FontSize::MEDIUM   => 'medium',
      Const::FontSize::LARGE    => 'large',
    }

    SWIPE_ACTION = {
      Const::SwipeAction::START       => 'start',
      Const::SwipeAction::STOP        => 'stop',
      Const::SwipeAction::PREVIEW     => 'preview',
      Const::SwipeAction::BOOKMARK    => 'bookmark',
      Const::SwipeAction::SAFARI      => 'safari',
      Const::SwipeAction::CHROME      => 'chrome',
      Const::SwipeAction::TWEET       => 'tweet',
      Const::SwipeAction::FACEBOOK    => 'facebook',
      Const::SwipeAction::POCKET      => 'pocket',
      Const::SwipeAction::INSTAPAPER  => 'instapaper',
      Const::SwipeAction::READABILITY => 'readability',
    }

    BOOKMARK_READER = {
      Const::BookmarkReader::SAFARI      => 'safari',
      Const::BookmarkReader::EMAIL       => 'email',
      Const::BookmarkReader::POCKET      => 'pocket',
      Const::BookmarkReader::INSTAPAPER  => 'instapaper',
      Const::BookmarkReader::READABILITY => 'readability',
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
