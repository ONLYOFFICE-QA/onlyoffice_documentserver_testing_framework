# frozen_string_literal: true

module OnlyofficeDocumentserverTestingFramework
  # Helper to handle files with external links
  module UpdateLinksHelper
    # @return [String] xpath of update links message
    def update_links_message_xpath
      '//span[contains(text(), "This workbook contains links to one or more external sources")]'
    end

    # @return [String] xpath of update button
    def xpath_update_button
      "#{update_links_message_xpath}/../../../..//button[@result='ok']"
    end

    # @return [String] xpath of don't update button
    def xpath_do_not_update_button
      "#{update_links_message_xpath}/../../../..//button[@result='cancel']"
    end

    # Handle update links dialog
    def handle_update_links_message(to_update)
      return unless @instance.selenium.element_visible?(update_links_message_xpath)

      if to_update
        @instance.selenium.click_on_locator(xpath_update_button)
      else
        @instance.selenium.click_on_locator(xpath_do_not_update_button)
      end
    end
  end
end
