class Channels::NewsSourceScreen < PM::GroupedTableScreen
  attr_accessor :id, :is_changed
  include BW::KVO

  def on_load
    @news_source = NewsSource.find(@id)
    @is_saved = false
    @is_changed = false
    memorize
    observe(self, :is_changed) do |old_value, new_value|
      if new_value
        Dispatch::Queue.main.async{ show_save_button }
      end
    end

    self.title = @news_source.name
    if self.is_changed
      show_save_button
    else
      set_nav_bar_button :right, system_item: :add, action: :on_add_button_tapped
    end
  end

  def will_dismiss
    unobserve(self, :is_changed)
    if @is_saved
      self.parent_screen.on_return(model_saved: @is_saved)
    else
      rollback
    end
  end

  def set_up_table_view
    super
  end

  def table_data
    name_field = create_text_field('name', 'name', 1)
    name_field.addTarget(self, action: 'name_field_blur:', forControlEvents: UIControlEventEditingDidEnd)
    url_field = create_text_field('url', 'http://example.com/rss', 1)
    url_field.addTarget(self, action: 'url_field_blur:', forControlEvents: UIControlEventEditingDidEnd)
    [
      {
        cells: [
          {
            title: 'Name',
            selectionStyle: UITableViewCellSelectionStyleNone,
            accessory: { view: name_field },
          },
          {
            title: 'URL',
            selectionStyle: UITableViewCellSelectionStyleNone,
            accessory: { view: url_field },
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
          {
            title: "Image Path",
            subtitle: @news_source.image_path,
            action: :on_image_path_cell_tapped,
            arguments: { menu: :image_path },
            accessoryType: UITableViewCellAccessoryDisclosureIndicator,
            cell_style: UITableViewCellStyleValue1,
          },
        ]
      },
      {
        title: '',
        cells: [
          {
            title: 'Preview',
            action: :open_news_source_feeds,
            accessoryType: UITableViewCellAccessoryDisclosureIndicator,
          },
        ]
      },
    ]
  end

  def textFieldShouldReturn(text_field)
    text_field.resignFirstResponder
    true    
  end

  def on_cell_tapped(args = {})
    property = args[:menu]
    open Channels::NewsSourceSelectScreen.new(
      nav_bar: true,
      news_source: @news_source,
      property: property,
      constant: property.to_s.camelize,
      constant_names: RN::Titles.const_get(property.to_s.upcase)
    )    
  end

  def on_image_path_cell_tapped(args = {})
    property = args[:menu]
    open Channels::NewsSourceSelectImagePathScreen.new(
      nav_bar: true,
      news_source: @news_source,
    )    
  end

  def memorize
    @last_name = @news_source.name
    @last_url = @news_source.url
    @last_category = @news_source.category
    @last_country = @news_source.country    
  end

  def rollback
    @news_source.name = @last_name 
    @news_source.url = @last_url
    @news_source.category = @last_category
    @news_source.country = @last_country
  end

  def show_save_button
    set_nav_bar_button :right, system_item: :save, action: :on_save_button_tapped    
  end

  def open_news_source_feeds
    open Channels::NewsSourceFeedsScreen.new(nav_bar: true, news_source: @news_source)        
  end

  def on_add_button_tapped
    action_sheet = UIActionSheet.alloc.init.tap do |as|
      as.delegate = self
      as.title = 'Add News Source'
      as.addButtonWithTitle('Create')
      as.addButtonWithTitle('Copy and Create')
      as.addButtonWithTitle('Cancel')
      as.cancelButtonIndex = 2
    end
    # action_sheet.showInView(self.window)
    action_sheet.showInView(self.view)    
  end

  def on_save_button_tapped
    if @news_source.valid?
      @news_source.save
      NewsSource.save_to_file
      @is_saved = true
    else
      App.alert @news_source.error_messages
    end
  end

  def name_field_blur(text_field)
    if text_field.text == @last_name
      return
    else
      @news_source.name = text_field.text
      self.is_changed = true
    end
  end

  def url_field_blur(text_field)
    if text_field.text == @last_url
      return
    else
      self.is_changed = true
    end

    url = NSURL.URLWithString(text_field.text)
    if url && url.scheme && url.host
      request = NSURLRequest.requestWithURL(url)
      if NSURLConnection.canHandleRequest(request)
        @news_source.url = text_field.text
        @news_source.host = url.host
      else
        App.alert 'invalid URL'
      end
    else
      App.alert 'invalid URL'
    end
  end

  def actionSheet(actionSheet, clickedButtonAtIndex: buttonIndex)
    case buttonIndex
    when 0
      @news_source = NewsSource.new
      update_table_data
      self.is_changed = true
    when 1
      copy = NewsSource.new({
        category: @news_source.category,
        country: @news_source.country,
        url: @news_source.url,
        host: @news_source.host,
        image_path: @news_source.image_path,
        })
      update_table_data
      self.is_changed = true
    end
  end

  def on_return(args = {})
    if args[:model_changed]
      update_table_data
      self.is_changed = true
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
