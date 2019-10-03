require_relative 'doc_test_site_functions/healthcheck_page'
require_relative 'doc_test_site_functions/doc_test_file_list'
require_relative 'doc_test_site_functions/doc_test_site_server_helper'
# Class to work with test examples
class DocTestSiteFunctions
  extend DocTestSiteServerHelper
  include PageObject

  # @return [Array<String>] list of supported languages
  SUPPORTED_LANGUAGES = %w[English
                           Bulgarian
                           Chinese
                           Czech
                           Dutch
                           French
                           German
                           Hungarian
                           Italian
                           Japanese
                           Korean
                           Latvian
                           Polish
                           Portuguese
                           Russian
                           Slovak
                           Slovenian
                           Spanish
                           Turkish
                           Ukrainian
                           Vietnamese].freeze
  select_list(:user_list, xpath: '//*[@id="user"]')
  select_list(:language_list, xpath: '//*[@id="language"]')

  def initialize(instance)
    super(instance.webdriver.driver)
    @instance = instance
    @xpath_begin_view = '//*[@id="beginView"]'
    @xpath_file_loading_step = '//*[@id="step1"]'
    @xpath_conversion_step = '//*[@id="step2"]'
    @xpath_editor_scripts_step = '//*[@id="step3"]'
    @xpath_file_entry = '//*[@class="stored-list"]/table/tbody/tr'
  end

  # Waiting for load of page
  # @return [Nothing]
  def wait_load
    @instance.webdriver.wait_until do
      doc_test_site?
    end
  end

  # reload the page
  # @return [Nothing]
  def reload
    @instance.webdriver.refresh
    wait_load
  end

  # Check if current site is DocTestSite
  # @return [true, false] result of checking
  def doc_test_site?
    result = @instance.selenium.element_present?(@xpath_begin_view)
    OnlyofficeLoggerHelper.log("Current server is a doc_test_site: #{result}")
    result
  end

  # Upload file to portal
  # @param [String] file_path like as '/mnt/data_share/Files/DOCX/empty.docx'
  def upload_file(file_path)
    file_path_absolute = file_path.gsub('~', ENV['HOME'])
    @instance.selenium.type_to_locator('//*[@id="fileupload"]', file_path_absolute, false, false, false, true)
    wait_loading_file
    wait_conversion
    wait_loading_scripts
    true
  end

  # Check for any error in loading process and raise it
  # @return [Nothing]
  def check_error
    error_message = @instance.selenium.get_text('//*[@class="error-message"]/span', false)

    @instance.selenium.webdriver_error("Error while uploading document. Error message: #{error_message}") unless error_message.empty?
  end

  # Waits until file converts
  # @return [Nothing]
  def wait_loading_file
    100.times do |current_time|
      OnlyofficeLoggerHelper.log("Waiting for file loading for #{current_time} seconds")
      return true if @instance.selenium.get_attribute(@xpath_file_loading_step, 'class').include?('done')

      sleep 1
      check_error
    end
    @instance.selenium.webdriver_error('File not finished for loading scripts for 100 seconds')
  end

  # Waits until file converts
  # @return [Nothing]
  def wait_conversion
    100.times do |current_time|
      OnlyofficeLoggerHelper.log("Waiting for file conversion for #{current_time} seconds")
      return true if @instance.selenium.get_attribute(@xpath_conversion_step, 'class').include?('done')

      sleep 1
      check_error
    end
    @instance.selenium.webdriver_error('File not finished for conversion for 100 seconds')
  end

  # Waits until scripts loads
  # @return [Nothing]
  def wait_loading_scripts
    100.times do |current_time|
      OnlyofficeLoggerHelper.log("Waiting for editors scripts load for #{current_time} seconds")
      return true if @instance.selenium.get_attribute(@xpath_editor_scripts_step, 'class').include?('done')

      sleep 1
      check_error
    end
    @instance.selenium.webdriver_error('File not finished for loading scripts for 100 seconds')
  end

  # Check if file uploaded
  # @return [Boolean]
  def file_uploaded?
    @instance.selenium.element_visible?(@xpath_begin_view)
  end

  # help-method to #open_file_in_editor and #open_file_in_viewer
  def open_file_in
    result = 'Unknown'
    if file_uploaded?
      yield
      sleep 5
      @instance.selenium.close_tab
      @instance.selenium.switch_to_main_tab
      result = @instance.management.wait_for_operation_with_round_status_canvas
      sleep 3 # just for sure
    end
    result
  end

  # Click on Edit Button and wait opening Editor
  # Return result of the opening Editor
  def open_file_in_editor
    open_file_in { @instance.selenium.click_on_locator('//*[@id="beginEdit"]') }
  end

  # Click on View Button and wait opening Viewer
  # Return result of the opening Viewer
  def open_file_in_viewer
    open_file_in { @instance.selenium.click_on_locator(@xpath_begin_view) }
  end

  # Get url of document which opened in editor
  # @return [String] url
  def current_document_storage_url
    page_source = @instance.selenium.get_page_source
    url_line = page_source.scan(/\"?url\"?: \".*$/).first
    url_line.delete('"').gsub('url: ', '').chop
  end

  # @return [True, False] is on file list page now?
  def file_list_opened?
    @instance.selenium.element_visible?('//*[contains(@class, "try-editor document")]')
  end

  # @return [Integer] count of uploaded files
  def uploaded_file_count
    @instance.selenium.get_element_count(@xpath_file_entry)
  end

  # @return [DocTestFileLIst] get file list
  def uploaded_file_list
    file_list = []
    (0...uploaded_file_count).each do |current_file_number|
      file_list << DocTestSiteFileListEntry.new(@instance, "#{@xpath_file_entry}[#{current_file_number + 1}]")
    end
    DocTestFileList.new(file_list)
  end

  # @return [Checkbox] save in original format checkbox
  def save_in_original_format
    checkbox = CheckBox.new(@instance)
    checkbox.xpath = '//*[@id="checkOriginalFormat"]'
    checkbox.count_of_frame = 0
    checkbox
  end

  # @return [Checkbox] Create a file filled with sample content
  def create_a_file_with_sample
    checkbox = CheckBox.new(@instance)
    checkbox.xpath = '//*[@id="createSample"]'
    checkbox.count_of_frame = 0
    checkbox
  end

  # Perform creating sample document
  # @return [String] result of opening
  def open_sample_document(format = :document, wait_to_load: true)
    case format
    when :document
      @instance.selenium.click_on_locator('//*[contains(@class, "try-editor document")]')
    when :spreadsheet
      @instance.selenium.click_on_locator('//*[contains(@class, "try-editor spreadsheet")]')
    when :presentation
      @instance.selenium.click_on_locator('//*[contains(@class, "try-editor presentation")]')
    else
      @instance.webdriver.webdriver_error("Unknown file type for open_sample_document(#{format})")
    end
    return unless wait_to_load

    @instance.selenium.close_tab
    @instance.selenium.switch_to_main_tab
    @instance.management.wait_for_operation_with_round_status_canvas
  end

  # @return [Nothing]
  def go_to_healthcheck
    @instance.webdriver.open("#{@instance.user_data.portal}/healthcheck")
  end

  # @return [HealthcheckPage] page of healthcheck
  def healthcheck
    @healthcheck = HealthcheckPage.new(@instance)
  end
end
