# frozen_string_literal: true

require_relative 'spreadsheet_editor/spreadsheet_windows'

module OnlyofficeDocumentserverTestingFramework
  # Class for all Spreadsheet Editor actions
  class SpreadsheetEditor
    def initialize(instance)
      @instance = instance
    end

    def windows
      @windows ||= SpreadsheetEditorWindows.new(@instance)
    end
  end
end
