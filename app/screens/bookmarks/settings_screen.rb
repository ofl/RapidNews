class Bookmarks::SettingsScreen < PM::GroupedTableScreen
  title BW::localized_string(:settings, "Setting")

  def on_load
    @readers = []
    RN::Titles::BOOKMARK_READER.each do |k, v|
      @readers.push({name: v, id: k})
    end
    @readers.sort! { |a, b| a[:id] <=> b[:id] }
  end

  def table_data
    @settings_table_data = [
      {
        cells: @readers.map{ |reader| create_cell reader }
      }
    ]
  end

  def create_cell(reader)
    {
      cell_identifier: "Cell",
      cell_style: UITableViewCellStyleDefault,
      selectionStyle: UITableViewCellSelectionStyleNone,
      title: reader[:name],
      action: :on_cell_tapped,
      accessoryType: UITableViewCellAccessoryDisclosureIndicator,
      arguments: {menu: :reader, id: reader[:id]},
    }
  end

  def on_cell_tapped(args = {})
    if args[:menu] == :reader
      if args[:id] == RN::Const::BookmarkReader::EMAIL
        open Bookmarks::EmailScreen.new(nav_bar: true)
      elsif args[:id] == RN::Const::BookmarkReader::POCKET
        open Bookmarks::PocketScreen.new(nav_bar: true)
      elsif args[:id] == RN::Const::BookmarkReader::READABILITY
        open Bookmarks::ReadabilityScreen.new(nav_bar: true)
      elsif args[:id] == RN::Const::BookmarkReader::SAFARI
        open Bookmarks::SafariScreen.new(nav_bar: true)
      end
    end      
  end

  def on_return(args = {})
    if args[:model_saved]
      update_table_data
    end
  end

  def will_dismiss
    self.parent_screen.on_return(model_saved: true)
  end
end
