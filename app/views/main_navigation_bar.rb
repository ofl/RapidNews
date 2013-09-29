class MainNavigationBar < UINavigationBar

  BUTTONS = [:settings_button, :channels_button, :bookmarks_button, :hide_menu_button]

  def initWithFrame(frame)
    super.tap do
      self.stylesheet = :main_navigation_bar
      self.stylename = :base_view
      self.barStyle = UIBarStyleBlack

      BUTTONS.each_with_index do |name, i|
        button(name).tap do |b|
          b.when(UIControlEventTouchUpInside) { on_button_tapped(i) }
        end
      end
    end
  end

  def on_button_tapped(index)
    self.delegate.send("on_navbar_#{BUTTONS[index]}_tapped".to_sym)
  end
end