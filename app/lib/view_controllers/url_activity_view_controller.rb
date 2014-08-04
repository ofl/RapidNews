# -*- coding: utf-8 -*-
class URLActivityViewController < UIActivityViewController
  def initWithDefaultActivities(activityItems)
    activities = []
    activities.push  TUSafariActivity.new
    activities.push  PocketActivity.new

    # if HTBHatenaBookmarkManager.sharedManager.authorized
    #   activities.push HTBHatenaBookmarkActivity.new
    # end
    # chrome = ARChromeActivity.new.tap do |activity|
    #   activity.activityTitle = "Chromeで開く"
    # end

    self.initWithActivityItems(activityItems, applicationActivities: activities)
    self.setValue(activityItems[0], forKey: "subject")
    self.excludedActivityTypes = [UIActivityTypeMessage, UIActivityTypePostToWeibo]
    self
  end
end
