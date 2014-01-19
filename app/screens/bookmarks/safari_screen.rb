class Bookmarks::SafariScreen < Bookmarks::ReaderScreen

  def on_load
    @is_saved = false
    self.title = BW::localized_string(:safari_reading_list, 'Safari Readin List')
  end

  def set_table_data
    @reader = RN::Const::BookmarkReader::SAFARI
    [create_button_cell]
  end
end
