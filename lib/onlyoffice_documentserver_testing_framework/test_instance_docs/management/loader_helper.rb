# frozen_string_literal: true

module OnlyofficeDocumentserverTestingFramework
  # Module for methods with loader of document
  module LoaderHelper
    # Check if any error from DocumentServer v2.5
    def check_2_5_version_error
      @instance.selenium.select_frame(@xpath_iframe, @xpath_iframe_count)
      base_error_message_xpath = '//div[contains(@class,"x-message-box")]'
      error_box_xpath = "#{base_error_message_xpath}/div[2]/div[1]/div[2]/span"
      if @instance.selenium.element_visible?(error_box_xpath) &&
         @instance.selenium.get_style_parameter(base_error_message_xpath, 'left')
                  .gsub('px', '').to_i.positive?
        error_text = @instance.selenium.get_text(error_box_xpath).tr("\n", ' ')
        @instance.selenium.webdriver_error("Server Error: #{error_text}")
      end
    end

    # Handle default error in alert
    def handle_error
      @instance.selenium.select_top_frame
      error = error_message_alert
      @instance.selenium.webdriver_error(error) unless error.nil?
      @instance.selenium.select_frame(@xpath_iframe, @xpath_iframe_count)
    end

    # Check for error message 3.0 version
    def error_message_alert
      alert_xpath = "//div[contains(@class,'asc-window modal alert')]"
      return unless visible?("#{alert_xpath}/div[2]/div[1]/div[2]/span") &&
                    selenium_functions(:get_style_parameter, alert_xpath, 'left')
                    .gsub('px', '').to_i.positive?

      error = selenium_functions(:get_text, "#{alert_xpath}/div[2]/div[1]/div[2]/span").tr("\n", ' ')
      "Server Error: #{error}"
    end

    alias get_error_message_alert error_message_alert
    extend Gem::Deprecate
    deprecate :get_error_message_alert, :error_message_alert, 2025, 1

    # Handle some more alert dialogs
    def handle_alert_dialog
      return unless @instance.selenium.element_visible?(@alert_dialog_span_xpath)

      error = @instance.selenium.get_text(@alert_dialog_span_xpath).tr("\n", ' ')
      @instance.selenium.webdriver_error("Server Error: #{error}")
    end
  end
end
