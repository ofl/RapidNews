# -*- coding: utf-8 -*-
class BookmarksScreen < PM::TableScreen
  stylesheet :bookmarks_screen

  def will_appear
    @view_is_set_up ||= set_up_view
  end

  def set_up_view
    self.title = 'Bookmarks'
    set_nav_bar_button :right, title: "Setting", action: :open_bookmark_settings
    set_nav_bar_button :left, system_item: :close, action: :on_close_button_tapped
    self.navigationController.setToolbarHidden(false, animated:false)
    @buttons ||= set_toolbar_buttons
    true
  end

  def set_toolbar_buttons
    toolbar_items = []
    spacer = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace,
                                                               target: nil,
                                                               action: nil)
    toolbar_items.push(spacer)
    @all_button = UIBarButtonItem.alloc.initWithTitle("All",
                                                        style: UIBarButtonItemStylePlain,
                                                        target: self,
                                                        action: "on_all_button_tapped")
    toolbar_items.push(@all_button)
    toolbar_items.push(spacer)
    @trash_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemTrash,
                                                                        target: self,
                                                                        action: "on_trash_button_tapped")
    toolbar_items.push(@trash_button)
    toolbar_items.push(spacer)
    App::Persistence['bookmark_readers'].each do |reader|
      button = UIBarButtonItem.alloc.initWithImage(UIImage.imageNamed(RN::Images::BOOKMARK_READER[reader]),
                                                   style: UIBarButtonItemStylePlain,
                                                   target: self,
                                                   action: "send_to_#{RN::Titles::BOOKMARK_READER[reader]}")
      toolbar_items.push(button)
      toolbar_items.push(spacer)
    end
    self.setToolbarItems(toolbar_items)
    true
  end

  def create_cell(article)
    button = UIButton.new
    button.when(UIControlEventTouchUpInside) { toggle_checked_button(article) }
    if article.is_checked
      set_attributes button, {stylename: :checked_button}
    else
      set_attributes button, {stylename: :nochecked_button}
    end
    {
      cell_identifier: "Cell",
      cell_style: UITableViewCellStyleDefault,
      title: article.title,
      indentationLevel: 2,
      selectionStyle: UITableViewCellSelectionStyleGray,
      arguments: article,
      subviews: [button],
    }
  end

  def table_data
    @bookmarks = Article.bookmarks
    [{ cells: @bookmarks.map{ |article|create_cell(article)}}]
  end

  def toggle_checked_button(article)
    article.is_checked = !article.is_checked
    article.save
    @is_saved = true
    update_table_data
  end

  def on_cell_tapped(article)
    p 'tapped'
  end

  def on_trash_button_tapped
    action_sheet = UIActionSheet.alloc.init.tap do |as|
      as.delegate = self
      as.title = 'Dissolve bookmarks'
      as.addButtonWithTitle('Dissolve Checked')
      as.addButtonWithTitle('Dissolve All')
      as.addButtonWithTitle('Cancel')
      as.cancelButtonIndex = 2
    end
    # action_sheet.showInView(self.window)
    action_sheet.showInView(self.view)
  end

  def on_all_button_tapped
    @bookmarks.each do |bookmark|
      bookmark.is_checked = true
      bookmark.save
    end
    update_table_data
  end

  def on_close_button_tapped
    close(model_saved: @is_saved)
  end

  def send_to_email
    unless MFMailComposeViewController.canSendMail
      App.alert("It is necessary to set the send mail")
      return
    end
    send_bookmarks = self.selected_bookmarks(RN::Const::BookmarkReader::EMAIL)
    unless send_bookmarks.count > 0
      App.alert("No bookmarks are selected.")
      return
    end
    c = MFMailComposeViewController.alloc.init
    c.setSubject(App::Persistence['email_subject'])
    c.setToRecipients(App::Persistence['email_to'])
    c.setCcRecipients(App::Persistence['email_cc'])
    c.setBccRecipients(App::Persistence['email_bcc'])
    c.setMessageBody(RN::EmailBody.html(send_bookmarks), isHTML: true)
    c.mailComposeDelegate = self
    self.presentModalViewController(c, animated:true)
  end

  def mailComposeController(controller, didFinishWithResult: result, error: error)
    if error
      App.alert("[Error]Can not send mail.")
    else
      case result
      when MFMailComposeResultSent
        cleanup(RN::Const::BookmarkReader::EMAIL)
      when MFMailComposeResultSaved
        NSLog('Saved')
      when MFMailComposeResultCancelled
        NSLog('Canceled')
        cleanup(RN::Const::BookmarkReader::EMAIL)
      when MFMailComposeResultFailed
        NSLog('Failed')
      else
        NSLog('Unknown')
      end
    end
    controller.dismissModalViewControllerAnimated(true)
  end

  def send_to_pocket
    if PocketAPI.sharedAPI.loggedIn?
      send_url_to_pocket
    else
      PocketAPI.sharedAPI.loginWithHandler(
        -> (pocket, error) do
          if error.nil?
            send_url_to_pocket
          else
            NSLog(error.localizedDescription)
          end
        end
      )
    end
  end

  def send_url_to_pocket
    reader = RN::Const::BookmarkReader::POCKET
    send_bookmarks = self.selected_bookmarks(reader)
    unless send_bookmarks.count > 0
      App.alert("No bookmarks are selected.")
      return
    end
    urls = send_bookmarks.map do |bookmark|
      {
        action: 'add',
        url: bookmark.link_url
      }
    end

    SVProgressHUD.showWithStatus("保存中...")
    PocketAPI.sharedAPI.callAPIMethod('v3/send',
                                      withHTTPMethod: PocketAPIHTTPMethodPOST,
                                      arguments: {actions: urls},
                                      handler: -> (api, apiMethod, response, error) {
                                        if error
                                          SVProgressHUD.showErrorWithStatus(error.localizedDescription)
                                        else
                                          cleanup(reader)
                                          SVProgressHUD.showSuccessWithStatus("保存しました")
                                        end
                                      }
                                      )
  end

  def send_to_readability
  end

  def send_to_instapaper
  end

  def send_to_safari
    reader = RN::Const::BookmarkReader::SAFARI
    send_bookmarks = self.selected_bookmarks(reader)
    unless send_bookmarks.count > 0
      App.alert("No bookmarks are selected.")
      return
    end
    readList = SSReadingList.defaultReadingList
    result = false
    send_bookmarks.each do |bookmark|
      error_ptr = Pointer.new(:object)
      result = readList.addReadingListItemWithURL(NSURL.URLWithString(bookmark.link_url),
                                                  title: bookmark.title,
                                                  previewText: bookmark.summary,
                                                  error: error_ptr)
      if result && App::Persistence['bookmark_desolve_after'].include?(reader)
        bookmark.is_bookmarked = false
        bookmark.is_checked = false
      end
    end
    update_table_data
  end

  def open_bookmark_settings
    open Bookmarks::SettingsScreen.new(nav_bar: true)
  end

  def actionSheet(actionSheet, clickedButtonAtIndex: buttonIndex)
    case buttonIndex
    when 0
      desolve_checked_bookmarks
    when 1
      desolve_all_bookmarks
    end
  end

  def on_return(args = {})
    if args[:model_saved]
      set_toolbar_buttons
    end
  end

  def selected_bookmarks(reader)
    is_send_all(reader) ? @bookmarks : checked_bookmarks
  end

  def checked_bookmarks
    @bookmarks.select{ |bookmark| bookmark.is_checked }
  end

  def cleanup(reader)
    if App::Persistence['bookmark_desolve_after'].include?(reader)
      if is_send_all(reader)
        desolve_all_bookmarks
      else
        desolve_checked_bookmarks
      end
    end
  end

  def is_send_all(reader)
    App::Persistence['bookmark_all_send'].include?(reader)
  end

  def desolve_checked_bookmarks
    desolve_bookmarks(self.checked_bookmarks)
    update_table_data
  end

  def desolve_all_bookmarks
    desolve_bookmarks(@bookmarks)
    update_table_data
  end

  def desolve_bookmarks(bookmarks)
    bookmarks.each do |bookmark|
      bookmark.is_bookmarked = false
      bookmark.is_checked = false
    end
  end
end
