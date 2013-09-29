module RapidNews
  module Preference
    def load
      App::Persistence['articles_size'] ||= RN::Const::ArticlesSize::SMALL
      App::Persistence['speed']      ||= RN::Const::Speed::FIXED
      App::Persistence['accelerate'] ||= RN::Const::Accelerate::YES
      App::Persistence['font_size']  ||= RN::Const::FontSize::MEDIUM
      App::Persistence['design']     ||= RN::Const::Design::BLACK
      App::Persistence['swipe_left'] ||= RN::Const::SwipeAction::PREVIEW
      App::Persistence['swipe_right'] ||= RN::Const::SwipeAction::BOOKMARK
      App::Persistence['lang']       ||= ['en_US', 'en_GB', 'ja_JP']
      App::Persistence['index']      ||= 0
      App::Persistence['bookmark_readers'] ||= [RN::Const::BookmarkReader::EMAIL, RN::Const::BookmarkReader::POCKET]
      App::Persistence['bookmark_desolve_after'] ||= []
      App::Persistence['bookmark_all_send'] ||= []
      App::Persistence['default_channel_id'] ||= 1
      App::Persistence['email_subject'] ||= 'Reading list :RapidNews'
      App::Persistence['email_to'] ||= []
      App::Persistence['email_cc'] ||= []
      App::Persistence['email_bcc'] ||= []
      App::Persistence['email_bcc'] ||= []
    end

    module_function :load
  end
end
