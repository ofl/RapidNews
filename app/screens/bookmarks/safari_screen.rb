class Bookmarks::SafariScreen < Bookmarks::ReaderScreen

  def on_load
    @is_saved = false
    self.title = 'Safari Readin List'
  end

  def set_table_data
    @reader = RN::Const::BookmarkReader::SAFARI
    [create_button_cell]
  end
end
