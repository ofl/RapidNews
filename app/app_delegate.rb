class AppDelegate < PM::Delegate

  status_bar false, animation: :none

  def on_load(app, options)
    load_data
    set_consumer_key

    open HomeScreen.new(nav_bar: true)
    self.window.tintColor = RN::Const::Color::TINT
  end

  def application(application, openURL: url, sourceApplication: s, annotation: a)
    if PocketAPI.sharedAPI.handleOpenURL(url)
      return true
    else
      return false
    end
  end

  private

  def load_data
    RN::Preference.load
    [Channel, NewsSource, Article].each do |klass|
      klass.load_from_file
    end
  end

  def set_consumer_key
    PocketAPI.sharedAPI.setConsumerKey(MY_ENV['pocket']['consumer_key'])
    # HTBHatenaBookmarkManager.sharedManager.setConsumerKey(MY_ENV['hatena']['consumer_key'],
    #                                                       consumerSecret: MY_ENV['hatena']['consumer_secret'])
  end
end

class Settings; end
class Bookmarks; end
class Channels; end
class Preview; end
