require 'onlyoffice_webdriver_wrapper'
require_relative 'test_instance_docs/common_editor/editor_windows'
require_relative 'test_instance_docs/doc_editor'
require_relative 'test_instance_docs/doc_service_welcome'
require_relative 'test_instance_docs/doc_test_site_functions'
require_relative 'test_instance_docs/spreadsheet_editor'
require_relative 'test_instance_docs/management'

module OnlyofficeDocumentserverTestingFramework
  class TestInstanceDocs
    attr_accessor :selenium
    alias webdriver selenium

    def initialize(webdriver: OnlyofficeWebdriverWrapper::WebDriver.new(:chrome))
      @selenium = webdriver
    end

    def doc_service_welcome
      @doc_service_welcome ||= DocServiceWelcome.new(self)
    end

    def doc_test_functions
      @doc_test_functions ||= DocTestSiteFunctions.new(self)
    end

    def doc_editor
      @doc_editor ||= DocEditor.new(self)
    end

    def spreadsheet_editor
      @spreadsheet_editor ||= SpreadsheetEditor.new(self)
    end

    def management
      @management ||= Management.new(self)
    end
  end
end
