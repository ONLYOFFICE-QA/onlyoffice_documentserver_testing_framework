# frozen_string_literal: true

require_relative 'management/loader_helper'
module OnlyofficeDocumentserverTestingFramework
  # Class for management main methods
  class Management
    include SeleniumWrapper
    include LoaderHelper

    attr_accessor :xpath_iframe_count
    attr_accessor :xpath_iframe

    def initialize(instance)
      @instance = instance
      @xpath_iframe_count = 1
      # Don't mixup iframe with help
      @xpath_iframe = '//iframe[not(contains(@src, "help")) and '\
                               'not(contains(@id, "fileFrame"))]'
    end

    # @return [Boolean] check if loader present
    def loading_present?
      if @instance.webdriver.alert_exists?
        raise 'Service Unavailable. There is alert while loading docs: '\
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
      loader8 = @instance.selenium.element_visible?(@xpath_window_modal)
      mobile_loader = wait_for_mobile_loading if main_frame_mobile_element_visible?
      @instance.selenium.select_top_frame
      loading = loader1 || loader2 || loader3 || loader4 || loader5 || loader6 || loader7 || loader8 || mobile_loader
      OnlyofficeLoggerHelper.log("Loading Present: #{loading}")
      loading
    end

    def main_frame_mobile_element_visible?
      @instance.selenium.element_visible?('//*[contains(@class,"framework7-root")]')
    end

    def wait_for_mobile_loading
      @instance.selenium.element_visible?('//*[contains(@class,"modal-preloader")]') ||
        @instance.selenium.element_visible?('//*[contains(@class,"loader-page")]') ||
        @instance.selenium.get_element('//*[contains(@class,"iScrollVerticalScrollbar")]').nil?
    end

    # Wait until loader is present
    # @param timeout [Integer] wait for loading to be present
    def wait_loading_present(timeout = 15)
      timer = 0
      while timer < timeout && !loading_present?
        sleep 1
        timer += 1
        OnlyofficeLoggerHelper.log("Waiting for start loading of documents. Waiting for #{timer} seconds of #{timeout}")
      end
      @instance.webdriver.webdriver_error("Waiting for start loading failed for #{timeout} seconds") if timer == timeout
    end

    # Wait for operation with round status in canvas editor
    # @param [Integer] timeout_in_seconds count of seconds to wait
    def wait_for_operation_with_round_status_canvas(timeout_in_seconds = 300, options = {})
      result = true
      OnlyofficeLoggerHelper.log('Start waiting for Round Status')

      current_wait_time = 0
      wait_until_frame_loaded
      while loading_present?
        sleep(1)
        current_wait_time += 1
        OnlyofficeLoggerHelper.log("Waiting for Round Status for #{current_wait_time} of #{timeout_in_seconds} timeout")
        @instance.doc_editor.windows.txt_options.txt_options = 'Unicode (UTF-8)'
        @instance.spreadsheet_editor.windows.csv_option.csv_options = options

        check_2_5_version_error

        @instance.selenium.select_top_frame
        error = error_message_alert
        @instance.selenium.webdriver_error(error) unless error.nil?
        @instance.selenium.select_frame(@xpath_iframe, @xpath_iframe_count)

        # Close 'Select Encoding' dialog if present
        if current_wait_time > timeout_in_seconds
          @instance.selenium.select_top_frame
          @instance.selenium.webdriver_error('Timeout for render file')
        end

        # Check for some error message
        if @instance.selenium.element_visible?('//div[@role="alertdialog"]/div/div/div/span')
          error = @instance.selenium.get_text('//div[@role="alertdialog"]/div/div/div/span').tr("\n", ' ')
          @instance.selenium.select_top_frame
          @instance.selenium.webdriver_error("Server Error: #{error}")
        end
        @instance.selenium.select_top_frame
        if permission_denied_message?
          @instance.selenium.webdriver_error('There is not enough access rights for document')
        end
        @instance.selenium.webdriver_error('The required file was not found') if file_not_found_message?
      end

      @instance.selenium.select_frame(@xpath_iframe, @xpath_iframe_count)
      if @instance.selenium.element_visible?('//div[@role="alertdialog"]/div/div/div/span')
        alert_text = @instance.selenium.get_text('//div[@role="alertdialog"]/div/div/div/span').tr("\n", ' ')
        result = "Server Alert: #{alert_text}"
        if result.include?('charts and images will be lost')
          style_left = @instance.selenium.get_style_parameter('//div[@role="alertdialog"]', 'left').gsub!('px', '').to_i
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
      result
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

    # Check for error message 3.0 version
    def error_message_alert
      alert_xpath = "//div[contains(@class,'asc-window modal alert')]"
      return unless visible?("#{alert_xpath}/div[2]/div[1]/div[2]/span") &&
                    selenium_functions(:get_style_parameter, alert_xpath, 'left')
                    .gsub('px', '').to_i.positive?

      "Server Error: #{selenium_functions(:get_text, "#{alert_xpath}/div[2]/div[1]/div[2]/span").tr("\n", ' ')}"
    end

    alias get_error_message_alert error_message_alert
    extend Gem::Deprecate
    deprecate :get_error_message_alert, :error_message_alert, 2025, 1

    def permission_denied_message?
      denied_xpath = '//div[contains(text(),"You don\'t have enough permission to view the file")]'
      @instance.selenium.select_frame
      error_on_loading = @instance.selenium.element_present?(denied_xpath)
      @instance.selenium.select_top_frame
      error_on_loading
    end

    def file_not_found_message?
      message_xpath = '//div[contains(@class, "tooltip-inner") and contains(text(),"The required file was not found")]'
      @instance.selenium.select_frame
      error_on_loading = @instance.selenium.element_visible?(message_xpath)
      @instance.selenium.select_top_frame
      OnlyofficeLoggerHelper.log("file_not_found_message is shown: #{error_on_loading}")
      error_on_loading
    end

    def add_error_handler
      js_handler = 'window.jsErrors = [];'\
                   'window.onerror = function(errorMessage) '\
                   '{window.jsErrors[window.jsErrors.length] = errorMessage;}'
      @instance.selenium.select_frame @instance.management.xpath_iframe
      @instance.selenium.execute_javascript(js_handler)
      @instance.selenium.select_top_frame
    end

    # @return [Symbol] editor typo of opened document
    def editor_type
      @instance.selenium.select_top_frame
      url = selenium_functions(:get_url)
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
  end
end
