class Bookmarks::PocketScreen < Bookmarks::ReaderScreen

  def on_load
    @is_saved = false
    self.title = 'Pocket'
  end

  def set_table_data
    @reader = RN::Const::BookmarkReader::POCKET
    title = PocketAPI.sharedAPI.loggedIn? ? BW::localized_string(:logout, 'Logout') : BW::localized_string(:login, 'Login')

    [
      create_button_cell,
      {
        title: BW::localized_string(:login, 'Login'),
        cells: [
          {
            title: title,
            accessoryType: UITableViewCellAccessoryDisclosureIndicator,
            action: :toggle_login, 
          }
        ]
      }
    ]
  end

  def toggle_login
    if PocketAPI.sharedAPI.loggedIn?
      PocketAPI.sharedAPI.logout
      update_table_data
    else
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
  end
end
