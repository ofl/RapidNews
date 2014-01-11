class Settings::SharesLoginScreen < PM::GroupedTableScreen
  attr_accessor :service

  def on_load
    @is_saved = false
    self.title = RN::Titles::SHARE_SERVICE[@service]
  end

  def table_data
    @data = set_table_data
  end

  def set_table_data
    logged_in = is_logged_in

    [
      {
        cells: [
          {
            title: 'Login',
            style: UITableViewCellStyleDefault,
            action: :login,
            textLabel: {
              color: !logged_in ? BW.rgb_color(0,255,0) : RN::Const::Color::DISABLE,
              textAlignment: UITextAlignmentCenter,
            },
            userInteractionEnabled: !logged_in
          },
          {
            title: 'Logout',
            style: UITableViewCellStyleDefault,
            action: :logout,
            textLabel: {
              color: logged_in ? BW.rgb_color(255,0,0) : RN::Const::Color::DISABLE,
              textAlignment: UITextAlignmentCenter,
            },
            userInteractionEnabled: logged_in,
          }
        ]
      }
    ]
  end

  def is_logged_in
  end

  def login
  end

  def logout
  end

  def will_dismiss
  end
end
