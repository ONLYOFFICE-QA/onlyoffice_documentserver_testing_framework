# frozen_string_literal: true

module OnlyofficeDocumentserverTestingFramework
  # Check different messages of document load
  module ManagerMessagesChecker
    # @return [Boolean] is permission denied message shown
    def permission_denied_message?
      denied_xpath = '//div[contains(text(),"You don\'t have enough permission to view the file")]'
      @instance.selenium.select_frame
      error_on_loading = @instance.selenium.element_present?(denied_xpath)
      @instance.selenium.select_top_frame
      error_on_loading
    end

    # @return [Boolean] is `File not found` message shown
    def file_not_found_message?
      message_xpath = '//div[contains(@class, "tooltip-inner") and '\
                      'contains(text(),"The required file was not found")]'
      @instance.selenium.select_frame
      error_on_loading = @instance.selenium.element_visible?(message_xpath)
      @instance.selenium.select_top_frame
      OnlyofficeLoggerHelper.log("file_not_found_message is shown: #{error_on_loading}")
      error_on_loading
    end
  end
end
