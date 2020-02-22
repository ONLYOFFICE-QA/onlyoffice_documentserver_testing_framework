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
  end
end
