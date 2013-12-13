class Settings::SharesHTBScreen < Settings::SharesLoginScreen

  def is_logged_in
    return true if HTBHatenaBookmarkManager.sharedManager.authorized
    false
  end

  def login
    # SVProgressHUD.showWithStatus("Login...")
    HTBHatenaBookmarkManager.sharedManager.logout
    NSNotificationCenter.defaultCenter.addObserver( self,
                                                    selector: 'showOAuthLoginView:',
                                                    name: KHTBLoginStartNotification,
                                                    object: nil )

    HTBHatenaBookmarkManager.sharedManager.authorizeWithSuccess( -> {
                                                                   # SVProgressHUD.showSuccessWithStatus("Logged in")
                                                                   update_table_data
                                                                 },
                                                                 failure: -> (error) {
                                                                   NSLog(error.localizedDescription)
                                                                   # SVProgressHUD.showSuccessWithStatus("Login Failed")
                                                                 }
                                                                 )
  end

  def logout
    HTBHatenaBookmarkManager.sharedManager.logout
    update_table_data
  end

  def showOAuthLoginView(notification)
    NSNotificationCenter.defaultCenter.removeObserver(self, 
                                                      name: KHTBLoginStartNotification, 
                                                      object:nil)
    req = notification.object
    navigationController = UINavigationController.alloc.initWithNavigationBarClass(HTBNavigationBar, 
                                                                                   toolbarClass: nil)
    viewController = HTBLoginWebViewController.alloc.initWithAuthorizationRequest(req)
    navigationController.viewControllers = [viewController]
    self.presentViewController(navigationController, animated: true, completion: nil)
  end
end
