# frozen_string_literal: true

module OnlyofficeDocumentserverTestingFramework
  # Module for Reopen file related methods
  module FileReopenHelper
    # Perform reopen after autosave
    # @param [Integer] timeout for wait for file to build
    # @return [Boolean] result of opening
    def reopen_after_autosave(timeout: 30)
      url = @instance.selenium.get_url
      leave_file_and_build_it(timeout: timeout)
      @instance.webdriver.open(url)
      @instance.management.wait_for_operation_with_round_status_canvas
    end

    private

    # Leave current opened file and wait until it's builder
    # @param [Integer] timeout for wait for file to build
    # @return [nil]
    def leave_file_and_build_it(timeout: 30)
      file_name = @instance.management.document_name
      size_before = @instance.integration_example_api.file_data(file_name)['pureContentLength'].to_i
      @instance.go_to_base_url
      @instance.webdriver.wait_until(timeout, "File `#{file_name}` is built") do
        file_data = @instance.integration_example_api.file_data(file_name)
        !file_data.nil? && file_data['pureContentLength'].to_i != size_before
      end
      OnlyofficeLoggerHelper.log("File: `#{file_name}` was built after editing")
    end
  end
end
