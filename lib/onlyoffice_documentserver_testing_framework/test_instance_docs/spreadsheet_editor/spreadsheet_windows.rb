require_relative 'spreadsheet_windows/csv_option'

module OnlyofficeDocumentserverTestingFramework
  # Windows of Spreadsheet Editor
  class SpreadsheetEditorWindows < EditorWindows
    def initialize(instance)
      @instance = instance
    end

    # @return [CsvOption] csv windows
    def csv_option
      @csv_option ||= CsvOption.new(@instance)
    end
  end
end
