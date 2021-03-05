# frozen_string_literal: true

require 'onlyoffice_webdriver_wrapper'
require_relative 'test_instance_docs/common_editor/editor_windows'
require_relative 'test_instance_docs/doc_editor'
require_relative 'test_instance_docs/doc_service_welcome'
require_relative 'test_instance_docs/doc_test_site_functions'
require_relative 'test_instance_docs/integration_example_api'
require_relative 'test_instance_docs/presentation_editor'
require_relative 'test_instance_docs/spreadsheet_editor'
require_relative 'test_instance_docs/management'

module OnlyofficeDocumentserverTestingFramework
  # Main class for browser instance
  class TestInstanceDocs
    attr_accessor :selenium
    # @return [String] base url of DocumentServer
    attr_reader :doc_server_base_url
    alias webdriver selenium

    # Initialize new instance
    # @param [OnlyofficeWebdriverWrapper::WebDriver] webdriver for test instance
    # @param [String] doc_server_base_url base url of DocumentServer
    def initialize(webdriver: OnlyofficeWebdriverWrapper::WebDriver.new(:chrome), doc_server_base_url: nil)
      @selenium = webdriver
      @doc_server_base_url = doc_server_base_url
    end

    # Open DocServer base url page
    def go_to_base_url
      webdriver.open(doc_server_base_url)
    end

    # @return [DocServiceWelcome] welcome page of DocumentServer
    def doc_service_welcome
      @doc_service_welcome ||= DocServiceWelcome.new(self)
    end

    # @return [DocTestSiteFunctions] methods for test site
    def doc_test_functions
      # Do not cache methods since they use PageObject and cause all sort of troubles
      # if test run several times with different webdriver
      DocTestSiteFunctions.new(self)
    end

    # @return [IntegrationExampleApi] for methods
    def integration_example_api
      @integration_example_api ||= IntegrationExampleApi.new(self)
    end

    # @return [DocEditor] Document Editor instance
    def doc_editor
      @doc_editor ||= DocEditor.new(self)
    end

    # @return [SpreadsheetEditor] Spreadsheet Editor instance
    def spreadsheet_editor
      @spreadsheet_editor ||= SpreadsheetEditor.new(self)
    end

    # @return [PresentationEditor] editor of presentations
    def presentation_editor
      @presentation_editor ||= PresentationEditor.new(self)
    end

    # @return [Management] management methods
    def management
      @management ||= Management.new(self)
    end

    # @return [Hash] Options read from environment variable
    def env_options
      return @env_options if @env_options

      raw_options = ENV['ONLYOFFICE_DS_TESTING_OPTIONS'] || '{}'
      @env_options = JSON.parse(raw_options)
      @env_options['IgnoredJSErrors'] = [] unless @env_options['IgnoredJSErrors']
      @env_options
    end
  end
end
