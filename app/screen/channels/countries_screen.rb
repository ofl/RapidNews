class Channels::CountriesScreen < PM::TableScreen
  def self.get_indexable
  end

  def will_present
  end

  def will_appear
    self.title = 'Countries'
 end

  def table_data
    @countries = [
      {name: 'Japan', locale: 'ja_JP'},
      {name: 'UK', locale: 'en_GB'},
      {name: 'USA', locale: 'en_US'},
    ] 
    [{ cells: @countries.map{ |country| create_cell country } }]
  end

  def create_cell(country)
    {
      cell_identifier: "Cell",
      cell_style: UITableViewCellStyleDefault,
      title: country[:name],
      action: :on_cell_tapped,
      accessoryType: UITableViewCellAccessoryDisclosureIndicator,
      arguments: {locale: country[:locale], name: country[:name]}
    }
  end

  def on_cell_tapped(args)
    open Channels::CountriesCompaniesScreen.new(nav_bar: true,
                                                locale: args[:locale], 
                                                country_name: args[:name])
  end

  def will_dismiss
  end
end