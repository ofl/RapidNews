class Channels::CountriesCompaniesScreen < PM::TableScreen
  attr_accessor :locale, :country_name

  def self.get_indexable
  end

  def will_present
  end

  def will_appear
    self.title = @country_name
  end

  def set_up_table_view    
    @companies = NewsCompany.where(:locale).eq(@locale).all
    @dictionary = {}
    @companies.each do |company|
      unless @dictionary[company.category]
        @dictionary[company.category] = []
      end
      @dictionary[company.category].push(company)
    end
    # @sorted_categories = @dictionary.allKeys.sortedArrayUsingSelector('compare:')    

    order = ['paper', 'tv', 'agency', 'magazine', 'sience', 'technology']
    @sorted_categories = @dictionary.keys.sort do |a,b|
      return 0 if order.index(a) == order.index(b)
      order.index(a) > order.index(b) ? 1 : 0
    end

    super
  end

  def table_data
    @sorted_categories.map do |category|
      {
        title: category, 
        cells: @dictionary[category].map{ |company| create_cell company }
      }
    end
  end

  def create_cell(company)
    {
      cell_identifier: "Cell",
      cell_style: UITableViewCellStyleDefault,
      title: company.name,
      action: :on_cell_tapped,
      accessoryType: UITableViewCellAccessoryDisclosureIndicator,
      arguments: {name: company.name, company_code: company.cc}
    }
  end

  def on_cell_tapped(args)
    open Channels::CountriesCompaniesSourcesScreen.new({nav_bar: true, 
                                                        company_name: args[:name], 
                                                        company_code: args[:company_code]})
  end

  def will_dismiss
  end
end