# frozen_string_literal: true

require_relative 'management/loader_helper'
require_relative 'management/manager_messages_checker'
require_relative 'management/password_protected_helper'
require_relative 'management/update_links_helper'
module OnlyofficeDocumentserverTestingFramework
  # Class for management main methods
  class Management
    include SeleniumWrapper
    include ManagerMessagesChecker
    include LoaderHelper
    include PasswordProtectedHelper
    include UpdateLinksHelper

    # @return [Integer] count of iframes to go into
    attr_accessor :xpath_iframe_count
    # @return [String] xpath to single iframe
    attr_accessor :xpath_iframe
    # Set file password
    attr_accessor :password
    # Set if should update links
    attr_accessor :to_update

    def initialize(instance)
      @instance = instance
      @xpath_iframe_count = 1
      # Don't mixup iframe with help
      @xpath_iframe = '//iframe[not(contains(@src, "/help/")) and ' \
                      'not(contains(@id, "fileFrame"))]'
      @alert_dialog_xpath = '//div[@role="alertdialog"]'
      @alert_dialog_span_xpath = "#{@alert_dialog_xpath}/div/div/div/span"
      @xpath_window_modal = "//div[contains(@class, 'asc-window modal')]"
      @xpath_anonymous_user_name_input = '//div[@id="id-dlg-username-caption"]'
      @to_update = false
    end

    # @return [Boolean] check if loader present
    def loading_present?
      if @instance.webdriver.alert_exists?
        raise 'Service Unavailable. There is alert while loading docs: ' \
              "\"#{@instance.webdriver.alert_text}\""
      end

      @instance.selenium.select_frame(@xpath_iframe, @xpath_iframe_count)
      mobile_loader = false
      loader1 = @instance.selenium.element_visible?('//div[contains(@id,"cmdloadmask")]')
      loader2 = @instance.selenium.element_visible?('//*[contains(@class,"loadmask")]')
      loader3 = @instance.selenium.element_visible?('//*[@class="asc-loadmask-body "]')
      loader4 = @instance.selenium.element_present?('//*[@id="loading-text"]')
      loader5 = @instance.selenium.element_visible?('//*[@id="loading-mask"]')
      loader6 = @instance.selenium.element_visible?('//*[@class="modals-mask"]')
      loader7 = @instance.selenium.element_visible?('//*[@class="asc-loadmask"]')
      loader8 = loading_blocking_modal_dialog?
      mobile_loader = wait_for_mobile_loading if main_frame_mobile_element_visible?
      @instance.selenium.select_top_frame
      loading = loader1 || loader2 || loader3 ||
                loader4 || loader5 || loader6 || loader7 ||
                loader8 || mobile_loader
      OnlyofficeLoggerHelper.log("Loading Present: #{loading}")
      loading
    end

    def main_frame_mobile_element_visible?
      @instance.selenium.element_visible?('//*[contains(@class,"framework7-root")]')
    end

    # Check if mobile loading is in progress
    # @return [True, False] is loading in progress
    def wait_for_mobile_loading
      @instance.selenium.element_visible?('//*[contains(@class,"modal-preloader")]') ||
        @instance.selenium.element_visible?('//*[contains(@class,"loader-page")]') ||
        @instance.selenium.element_visible?('//div[contains(@class, "dialog-preloader")]') ||
        @instance.selenium.get_element('//*[contains(@class,"iScrollVerticalScrollbar")]').nil?
    end

    # Wait until loader is present
    # @param timeout [Integer] wait for loading to be present
    def wait_loading_present(timeout = 15)
      timer = 0
      while timer < timeout && !loading_present?
        sleep 1
        timer += 1
        OnlyofficeLoggerHelper.log('Waiting for start loading of documents. ' \
                                   "Waiting for #{timer} seconds of #{timeout}")
      end
      return unless timer == timeout

      @instance.webdriver.webdriver_error("Waiting for start loading failed for #{timeout} seconds")
    end

    # Wait for operation with round status in canvas editor
    # @param [Integer] timeout_in_seconds count of seconds to wait
    # @param [Hash] options additional options
    # @option options [Integer] :additional_wait additional after file open. 0 by default
    def wait_for_operation_with_round_status_canvas(timeout_in_seconds = 300, options = {})
      result = true
      OnlyofficeLoggerHelper.log('Start waiting for Round Status')

      current_wait_time = 0
      wait_until_frame_loaded
      wait_for_round_loading_to_start
      while loading_present?
        sleep(1)
        current_wait_time += 1
        OnlyofficeLoggerHelper.log('Waiting for Round Status for ' \
                                   "#{current_wait_time} of " \
                                   "#{timeout_in_seconds} timeout")
        @instance.doc_editor.windows.txt_options.txt_options = 'Unicode (UTF-8)'
        @instance.spreadsheet_editor.windows.csv_option.csv_options = options

        check_2_5_version_error
        handle_update_links_message(to_update)
        handle_error

        # Close 'Select Encoding' dialog if present
        if current_wait_time > timeout_in_seconds
          @instance.selenium.select_top_frame
          @instance.selenium.webdriver_error('Timeout for render file')
        end
        handle_alert_dialog
        handle_password_protection(password)
        @instance.selenium.select_top_frame
        if permission_denied_message?
          @instance.selenium.webdriver_error('There is not enough access rights for document')
        end
        @instance.selenium.webdriver_error('The required file was not found') if file_not_found_message?
      end

      @instance.selenium.select_frame(@xpath_iframe, @xpath_iframe_count)
      if @instance.selenium.element_visible?(@alert_dialog_span_xpath)
        alert_text = @instance.selenium.get_text(@alert_dialog_span_xpath).tr("\n", ' ')
        result = "Server Alert: #{alert_text}"
        if result.include?('charts and images will be lost')
          style_left = @instance.selenium.get_style_parameter(@alert_dialog_xpath,
                                                              'left')
                                .gsub!('px', '').to_i
          result = true if style_left.negative?
        end
        @instance.selenium.select_top_frame
        return result
      elsif @instance.selenium.element_visible?(@xpath_error_window)
        result = "Server Error: #{@instance.selenium.get_text(@xpath_error_window_text).tr("\n", ' ')}"
        @instance.selenium.select_top_frame
        @instance.selenium.webdriver_error(result)
      end

      @instance.selenium.execute_javascript('window.onbeforeunload = null') # OFF POPUP WINDOW
      @instance.selenium.select_top_frame
      add_error_handler
      sleep(options.fetch(:additional_wait, 0))
      result
    end

    # Since v6.0.0 of DocumentServer
    # round loading mask start to appear not instantly
    # but after some timeout specified in
    # https://github.com/ONLYOFFICE/web-apps/commit/a7988dc7ec1f1151ef2c204677d1746a65e39132#diff-eee9ef38f1b712adf8bcc94c29de431aR127
    def wait_for_round_loading_to_start
      appear_timeout = 0.5
      sleep(appear_timeout * 4) # quad just in case, double is not enough
    end

    # @return [Boolean] check if frame with editor is loaded
    def frame_loaded?
      @instance.selenium.select_frame(@xpath_iframe, @xpath_iframe_count)
      loaded = @instance.selenium.element_visible?('//*[@id="viewport"]') ||
               @instance.selenium.element_visible?('//*[@id="editor_sdk"]')
      @instance.selenium.select_top_frame
      loaded
    end

    # @return [Void] wait until iframe have some content
    def wait_until_frame_loaded
      @instance.webdriver.wait_until do
        frame_loaded?
      end
    end

    # Add js code to handle JS errors
    # @return [nil]
    def add_error_handler
      js_handler = 'window.jsErrors = [];' \
                   'window.onerror = function(errorMessage) ' \
                   '{window.jsErrors[window.jsErrors.length] = errorMessage;}'
      @instance.selenium.select_frame @instance.management.xpath_iframe
      @instance.selenium.execute_javascript(js_handler)
      @instance.selenium.select_top_frame
    end

    # @return [Symbol] editor typo of opened document
    def editor_type
      @instance.selenium.select_top_frame
      url = selenium_functions(:current_url)
      case url
      when /documenteditor/
        :document
      when /spreadsheeteditor/
        :spreadsheet
      when /presentationeditor/
        :presentation
      else
        @instance.selenium.webdriver_error "Unknown editor type for url: #{url}"
      end
    end

    # @return [True, False] is there is loading blocking modals dialog
    def loading_blocking_modal_dialog?
      return false unless @instance.selenium.element_visible?(@xpath_window_modal)
      return false if @instance.selenium.element_visible?(@xpath_anonymous_user_name_input)

      true
    end

    # Get name of currently opened document
    # @param [Boolean] with_extension - should extension be included
    # @return [String]
    def document_name(with_extension: true)
      doc_name = @instance.doc_editor.top_toolbar.top_toolbar.document_name
      doc_name.chop! if status_save?(doc_name)
      doc_name = File.basename(doc_name, '.*') unless with_extension
      doc_name
    end

    # Check if document has not be saved until now
    # @param [String] name of document
    # @return [Boolean] result of that check
    def status_save?(name = nil)
      name ||= @instance.doc_editor.top_toolbar.top_toolbar.document_name
      name[-1] == '*'
    end

    # Check if opened document is in viewer
    # @return [true, false] true if viewer, false if editor
    def viewer?
      canvas_loaded = canvas_editor?
      tabs_present = @instance.doc_editor.top_toolbar.home_tab.present?
      result = canvas_loaded && !tabs_present
      OnlyofficeLoggerHelper.log("viewer?: #{result}")
      result
    end

    # Check if opened editor is canvas editor
    # @return [true, false] true if canvas, false if not canvas
    def canvas_editor?
      visible?('//*[@id="id_viewer"]') || visible?('//*[@id="ws-canvas"]')
    end
  end
end
