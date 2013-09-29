class Channels::CountriesCompaniesSourcesScreen < PM::TableScreen
  attr_accessor :company_name, :company_code

  def self.get_indexable
  end

  def will_present
  end

  def will_appear
    self.title = @company_name
  end

  def set_up_table_view
    @news_sources = NewsSource.where(:cc).eq(@company_code).all
    super
  end

  def table_data
    [{
        cells: @news_sources.map{ |news_source| create_cell news_source }
    }]
  end

  def create_cell(news_source)
    {
      cell_identifier: "Cell",
      cell_style: UITableViewCellStyleDefault,
      title: news_source.name,
      action: :on_cell_tapped,
      accessoryType: UITableViewCellAccessoryDisclosureIndicator,
      arguments: {id: news_source.id}
    }
  end

  def on_cell_tapped(args)
    open Channels::CountriesSourcesDetailScreen.new(nav_bar: true, 
                                                    id: args[:id], 
                                                    company_name: @company_name)
  end

  def will_dismiss
  end
end