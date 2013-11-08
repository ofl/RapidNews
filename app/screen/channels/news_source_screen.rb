class Channels::NewsSourceScreen < PM::GroupedTableScreen
  attr_accessor :id

  def self.get_indexable
  end

  def will_present
    @is_saved = false
  end

  def will_appear
    self.title = @news_source.name
  end

  def set_up_table_view
    @news_source = NewsSource.find(@id)
    @channels = Channel.order(:position).all
    super
  end

  def table_data
    [
      {
        cells: [
          {
            title: 'Name',
            selectionStyle: UITableViewCellSelectionStyleNone,
            accessory: { view: create_text_field('name', 'name', 1) },
          },
          {
            title: 'URL',
            selectionStyle: UITableViewCellSelectionStyleNone,
            accessory: { view: create_text_field('url', 'http://example.com/rss', 1) },
          },
          {
            title: 'Preview',
            action: :open_news_source_feeds,
            accessoryType: UITableViewCellAccessoryDisclosureIndicator,
          },
        ]
      },
      {
        title: '',
        cells: [
          {
            title: "Category",
            subtitle: RN::Titles::CATEGORY[@news_source.category],
            action: :on_cell_tapped,
            arguments: { menu: :category },
            accessoryType: UITableViewCellAccessoryDisclosureIndicator,
            cell_style: UITableViewCellStyleValue1,
          },
          {
            title: "Country",
            subtitle: RN::Titles::COUNTRY[@news_source.country],
            action: :on_cell_tapped,
            arguments: { menu: :country },
            accessoryType: UITableViewCellAccessoryDisclosureIndicator,
            cell_style: UITableViewCellStyleValue1,
          },
        ]
      }
    ]
  end

  def will_dismiss
  end

  def on_cell_tapped(args = {})
    property = args[:menu]
    open Channels::NewsSourceSelectScreen.new(
      nav_bar: true,
      id: @news_source.id,
      property: property,
      constant: property.to_s.camelize,
      constant_names: RN::Titles.const_get(property.to_s.upcase)
    )    
  end

  def open_news_source_feeds
    open Channels::NewsSourceFeedsScreen.new(nav_bar: true, id: @news_source.id)        
  end

  def on_return(args = {})
    if args[:model_saved]
      update_table_data
    end
  end

  def create_text_field(property, placeholder, tag_id)
    text = @news_source.send(property.to_sym)

    text_field = UITextField.alloc.initWithFrame(CGRectMake(100, 10, 200, 22)).tap do |tf|
      tf.delegate = self
      tf.text = text
      tf.autocorrectionType = UITextAutocorrectionTypeNo
      tf.autocapitalizationType = UITextAutocapitalizationTypeNone
      tf.textAlignment = UITextAlignmentRight
      tf.returnKeyType = UIReturnKeyDone
      tf.placeholder = placeholder
      tf.tag = tag_id
    end
  end

end
