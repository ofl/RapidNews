module RapidNews
  module Preference
    def load
      App::Persistence['articles_size'] ||= RN::Const::ArticlesSize::SMALL
      App::Persistence['appearence']     ||= RN::Const::Appearence::BLWH
      App::Persistence['swipe_left'] ||= RN::Const::SwipeLeft::PREVIEW
      App::Persistence['swipe_right'] ||= RN::Const::SwipeRight::BOOKMARK
      App::Persistence['show_picture'] = App::Persistence['show_picture'].nil? ? true : App::Persistence['show_picture']
      App::Persistence['lang']       ||= ['en_US', 'en_GB', 'ja_JP']
      App::Persistence['index']      ||= 0
      App::Persistence['bookmark_readers'] ||= [
        RN::Const::BookmarkReader::EMAIL, 
        RN::Const::BookmarkReader::POCKET, 
        RN::Const::BookmarkReader::SAFARI
      ]
      App::Persistence['bookmark_desolve_after'] ||= []
      App::Persistence['bookmark_all_send'] ||= []
      App::Persistence['default_channel_id'] ||= 1
      App::Persistence['email_subject'] ||= BW::localized_string(:email_title, 'Reading list :RapidNews')
      App::Persistence['email_to'] ||= []
      App::Persistence['email_cc'] ||= []
      App::Persistence['email_bcc'] ||= []
      App::Persistence['email_bcc'] ||= []
      App::Persistence['interval'] ||= 3.0
    end

    module_function :load
  end
end
