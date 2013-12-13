class Settings::SharesPocketScreen < Settings::SharesLoginScreen

  def is_logged_in
    return true if PocketAPI.sharedAPI.loggedIn?
    false
  end

  def login
    PocketAPI.sharedAPI.logout
    PocketAPI.sharedAPI.loginWithHandler(
      -> (pocket, error) do
        if error.nil?
          update_table_data
        else
          NSLog(error.localizedDescription)
        end
      end
    )
  end

  def logout
    PocketAPI.sharedAPI.logout
    update_table_data
  end
end