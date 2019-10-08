# frozen_string_literal: true

module OnlyofficeDocumentserverTestingFramework
  # Class for CSV window
  class CsvOption < TxtOptions
    include SeleniumWrapper

    def initialize(instance)
      @instance = instance
      @xpath_codepage_selector = '//*[contains(text(), "CSV")]/../..//div[@id="id-codepages-combo"]'
    end

    DELIMITER_TYPE = %i[comma semicolon colon tab space other].freeze

    # region CVN Framework
    def delimiter
      BoundComboBoxUl.new(@instance, '//*[@id="id-delimiters-combo"]', nil, 'span')
    end

    # @return [TextInput] text input for enter custom delimiter
    def other_delimiter
      @other_delimiter ||= TextInput.new(@instance, '//*[@id="id-delimiter-other"]')
    end

    # endregion

    # region Function

    # @param [Symbol] delimiter_type like as :semicolon
    def delimiter_select(delimiter_type)
      if DELIMITER_TYPE.include?(delimiter_type)
        delimiter.select_by_number(DELIMITER_TYPE.index(delimiter_type) + 1)
      else
        delimiter.select_by_number(DELIMITER_TYPE.index(:other) + 1)
        other_delimiter.set(delimiter_type)
      end
    end

    def set_csv_options(options = {})
      options[:encoding_to_set] ||= 'Unicode (UTF-8)'
      options[:csv_delimiter] ||= :comma
      return unless dialog_window_opened?

      encoding_select options[:encoding_to_set]
      delimiter_select options[:csv_delimiter]
      click_on_ok
    end
    # endregion
  end
end
