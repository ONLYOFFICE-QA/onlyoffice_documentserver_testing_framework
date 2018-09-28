module OnlyofficeDocumentserverTestingFramework
  class Loader
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
        @instance.doc_editor.windows.txt_options.set_txt_options
        @instance.spreadsheet_editor.windows.csv_option.set_csv_options(options)

        # Check for error message 2.5 version
        @instance.selenium.select_frame(@xpath_iframe, @xpath_iframe_count)
        if @instance.selenium.element_visible?('//div[contains(@class,"x-message-box")]/div[2]/div[1]/div[2]/span') &&
            @instance.selenium.get_style_parameter('//div[contains(@class,"x-message-box")]', 'left').gsub('px', '').to_i > 0
          @instance.selenium.webdriver_error('Server Error: ' + @instance.selenium.get_text('//div[contains(@class,"x-message-box")]/div[2]/div[1]/div[2]/span').tr("\n", ' '))
        end

        @instance.selenium.select_top_frame
        error = get_error_message_alert
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
        @instance.selenium.webdriver_error('There is not enough access rights for document') if permission_denied_message?
        @instance.selenium.webdriver_error('The required file was not found') if file_not_found_message?
      end

      @instance.selenium.select_frame(@xpath_iframe, @xpath_iframe_count)
      if @instance.selenium.element_visible?('//div[@role="alertdialog"]/div/div/div/span')
        result = 'Server Alert: ' + @instance.selenium.get_text('//div[@role="alertdialog"]/div/div/div/span').tr("\n", ' ')
        if result.include?('charts and images will be lost')
          style_left = @instance.selenium.get_style_parameter('//div[@role="alertdialog"]', 'left').gsub!('px', '').to_i
          result = true if style_left < 0
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
  end
end