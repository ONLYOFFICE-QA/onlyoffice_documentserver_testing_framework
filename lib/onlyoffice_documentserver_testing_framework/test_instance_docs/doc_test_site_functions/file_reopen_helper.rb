# frozen_string_literal: true

module OnlyofficeDocumentserverTestingFramework
  # Module for Reopen file related methods
  module FileReopenHelper
    # Perform reopen after autosave
    def reopen_after_autosave
      url = @instance.selenium.get_url
      leave_file_and_build_it
      @instance.webdriver.open(url)
      @instance.management.wait_for_operation_with_round_status_canvas
    end

    private

    # Leave current opened file and wait until it's builder
    # @return [nil]
    def leave_file_and_build_it
      file_name = @instance.management.document_name
      size_before = @instance.integration_example_api.file_data(file_name)['pureContentLength'].to_i
      @instance.go_to_base_url
      @instance.webdriver.wait_until do
        file_data = @instance.integration_example_api.file_data(file_name)
        !file_data.nil? && file_data['pureContentLength'].to_i != size_before
      end
      OnlyofficeLoggerHelper.log("File: `#{file_name}` was built after editing")
    end
  end
end
