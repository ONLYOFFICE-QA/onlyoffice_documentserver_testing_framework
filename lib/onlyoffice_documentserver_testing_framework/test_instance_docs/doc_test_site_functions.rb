# frozen_string_literal: true

require_relative 'doc_test_site_functions/healthcheck_page'
require_relative 'doc_test_site_functions/doc_test_file_list'
require_relative 'doc_test_site_functions/doc_test_site_server_helper'
require_relative 'doc_test_site_functions/file_reopen_helper'
require_relative 'doc_test_site_functions/password_protected_conversion_helper'
# Class to work with test examples
class DocTestSiteFunctions
  extend DocTestSiteServerHelper
  include PageObject
  include OnlyofficeDocumentserverTestingFramework::FileReopenHelper
  include OnlyofficeDocumentserverTestingFramework::PasswordProtectedConversionHelper

  select_list(:user_list, xpath: '//*[@id="user"]')
  select_list(:language_list, xpath: '//*[@id="language"]')

  def initialize(instance, edit_modes_indexes = default_modes_indexes)
    super(instance.webdriver.driver)
    @instance = instance
    @xpath_begin_view = '//*[@id="beginView"]'
    @xpath_file_loading_step = '//*[@id="step1"]'
    @xpath_conversion_step = '//*[@id="step2"]'
    @xpath_editor_scripts_step = '//*[@id="step3"]'
    @xpath_file_entry = '//*[@class="stored-list"]//table/tbody/tr'
    @xpath_create_doc = '//*[contains(@class, "try-editor document")]|' \
                        '//*[contains(@class, "try-editor word")]'
    @xpath_create_workbook = '//*[contains(@class, "try-editor spreadsheet")]|' \
                             '//*[contains(@class, "try-editor cell")]'
    @xpath_create_presentation = '//*[contains(@class, "try-editor presentation")]|' \
                                 '//*[contains(@class, "try-editor slide")]'
    @edit_modes_indexes = edit_modes_indexes
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
    sleep(1) # TODO: remove after update to Chromedriver 80
    result = @instance.selenium.element_present?(@xpath_begin_view)
    OnlyofficeLoggerHelper.log("Current server is a doc_test_site: #{result}")
    result
  end

  # Upload file to portal
  # @param [String] file_path like as '/mnt/data_share/Files/DOCX/empty.docx'
  def upload_file(file_path)
    file_path_absolute = file_path.gsub('~', Dir.home)
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

    return if error_message.empty?

    @instance.selenium.webdriver_error('Error while uploading document. ' \
                                       "Error message: #{error_message}")
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

      if @instance.selenium.element_visible?(xpath_input_password)
        handle_password_protection(@instance.management.password)
      end
      sleep 1
      check_error
    end
    @instance.selenium.webdriver_error('File not finished for conversion for 100 seconds')
  end

  # Checks if Loading editor scripts step of file upload is present
  # @return [Nothing]
  def final_loading_step_xpath
    return @xpath_editor_scripts_step if @instance.selenium.element_visible?(@xpath_editor_scripts_step)

    @xpath_conversion_step
  end

  # Waits until scripts loads
  # @return [Nothing]
  def wait_loading_scripts
    100.times do |current_time|
      OnlyofficeLoggerHelper.log("Waiting for editors scripts load for #{current_time} seconds")
      return true if @instance.selenium.get_attribute(final_loading_step_xpath, 'class').include?('done')

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
    page_source = @instance.selenium.page_source
    url_line = page_source.scan(/"?url"?: ".*$/).first
    pretty_url = url_line.delete('"').gsub('url: ', '').chop
    pretty_url.gsub(/&useraddress=.*/, '')
  end

  # @return [True, False] is on file list page now?
  def file_list_opened?
    @instance.selenium.element_visible?(@xpath_create_doc)
  end

  # @return [Integer] count of uploaded files
  def uploaded_file_count
    @instance.selenium.get_element_count(@xpath_file_entry)
  end

  # @return [DocTestFileLIst] get file list
  def uploaded_file_list
    file_list = (0...uploaded_file_count).map do |current_file_number|
      DocTestSiteFileListEntry.new(@instance,
                                   "#{@xpath_file_entry}[#{current_file_number + 1}]",
                                   @edit_modes_indexes)
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
      @instance.selenium.click_on_locator(@xpath_create_doc)
    when :spreadsheet
      @instance.selenium.click_on_locator(@xpath_create_workbook)
    when :presentation
      @instance.selenium.click_on_locator(@xpath_create_presentation)
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
    @instance.webdriver.open("#{@instance.user_data.portal}healthcheck")
  end

  # @return [HealthcheckPage] page of healthcheck
  def healthcheck
    @healthcheck = HealthcheckPage.new(@instance)
  end

  # @param [DocumentServerVersion] version of server
  # @return [Array<String>] list of supported languages
  def self.supported_languages(version = OnlyofficeDocumentserverTestingFramework::DocumentServerVersion.new(8, 3, 0))
    version_class = OnlyofficeDocumentserverTestingFramework::DocumentServerVersion
    version_mappings = [
      [version_class.new(8, 2), 'doc_test_site_languages_after_8_3.list'],
      [version_class.new(8, 2), 'doc_test_site_languages_after_8_2.list'],
      [version_class.new(8, 1), 'doc_test_site_languages_after_8_1.list'],
      [version_class.new(8, 0), 'doc_test_site_languages_after_8_0.list'],
      [version_class.new(7, 4), 'doc_test_site_languages_after_7_4.list'],
      [version_class.new(7, 3), 'doc_test_site_languages_after_7_3.list'],
      [version_class.new(7, 2), 'doc_test_site_languages_after_7_2.list'],
      [version_class.new(7, 1), 'doc_test_site_languages_after_7_1.list'],
      [version_class.new(6, 2), 'doc_test_site_languages_after_6_2.list']
    ]

    file = 'doc_test_site_languages_before_6_2.list'

    version_mappings.each do |ver, file_name|
      if version >= ver
        file = file_name
        break
      end
    end

    File.readlines("#{File.expand_path('..', __dir__)}" \
                   '/test_instance_docs/doc_test_site_functions/' \
                   "languages_list/#{file}")
        .map(&:strip)
  end

  private

  # Indexes of different modes
  # @return [Hash] name with index
  def default_modes_indexes
    {
      comment_mode: 4,
      review_mode: 5,
      fill_forms: 7,
      view_mode: 8,
      embedded: 10
    }
  end
end
