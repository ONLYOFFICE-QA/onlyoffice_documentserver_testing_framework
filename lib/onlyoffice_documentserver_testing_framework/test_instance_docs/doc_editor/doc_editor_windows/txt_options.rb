# frozen_string_literal: true

module OnlyofficeDocumentserverTestingFramework
  # Class for TXT export window
  class TxtOptions
    include SeleniumWrapper

    def initialize(instance)
      @xpath_codepage_selector = '//*[contains(text(), "TXT")]/../..//div[@id="id-codepages-combo"]'
    end

    # region CVN Framework

    def dialog_window_opened?
      visible = visible? @xpath_codepage_selector
      OnlyofficeLoggerHelper.log("Codepage option window is opened: #{visible}")
      visible
    end

    def loose_data_warning_present?
      visible = visible? '//*[contains(@class, "asc-window modal alert")]'
      OnlyofficeLoggerHelper.log("Codepage option window is opened: #{visible}")
      visible
    end

    def click_on_ok
      click_on_button '//button[@result="ok"]'
      OnlyofficeLoggerHelper.log('Click on OK button')
    end

    def click_on_cancel
      click_on_button '//button[@result="cancel"]'
      OnlyofficeLoggerHelper.log('Click on CANCEL button')
    end

    def encoding
      BoundComboBoxUl.new(@instance, @xpath_codepage_selector, nil, 'span')
    end

    def scroll_encoding_list_to(list_item_number)
      selenium_functions(:scroll_list_by_pixels,
                         "//*[@id='id-codepages-combo']/span/ul",
                         (list_item_number - 1) * 25)
      OnlyofficeLoggerHelper.log("Scroll to #{list_item_number} element")
    end

    # endregion

    # region Function

    def wait_warning
      counter = 0
      while !loose_data_warning_present? && counter < 30
        sleep 1
        counter += 1
      end
      @instance.webdriver.webdriver_error 'Wait for TXT warning failed' if counter == 30
    end

    def wait_options
      counter = 0
      while !dialog_window_opened? && counter < 30
        sleep 1
        counter += 1
      end
      @instance.webdriver.webdriver_error 'Wait for TXT options failed' if counter == 30
    end

    # @param [String] encoding_name like as 'French Canadian (DOS)'
    def encoding_select(encoding_name)
      encoding.open
      # TODO: Replace with correct include after find out https://github.com/ONLYOFFICE/testing-documentserver/pull/2006
      list_item_number = encoding.items_text.index { |item| item.include?(encoding_name) } + 1
      scroll_encoding_list_to list_item_number
      encoding.select_by_number list_item_number
    end

    def txt_options=(encoding_to_set = nil)
      return unless dialog_window_opened?

      encoding_to_set = encoding.items_text.last if encoding_to_set.nil?
      encoding_select encoding_to_set
      click_on_ok
    end

    alias set_txt_options txt_options=
    extend Gem::Deprecate
    deprecate :set_txt_options, :txt_options=, 2025, 1

    def close_warning_loose_data
      click_on_ok if loose_data_warning_present?
    end
    # endregion
  end
end
