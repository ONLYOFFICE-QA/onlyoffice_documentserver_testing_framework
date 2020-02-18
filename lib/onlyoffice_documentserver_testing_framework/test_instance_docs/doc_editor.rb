# frozen_string_literal: true

require_relative 'doc_editor/doc_editor_top_toolbar'
require_relative 'doc_editor/doc_editor_windows'

module OnlyofficeDocumentserverTestingFramework
  # Class for all Doc Editor actions
  class DocEditor
    def initialize(instance)
      @instance = instance
    end

    # @return [DocEditorTopToolbar] top toolbar
    def top_toolbar
      @top_toolbar ||= DocEditorTopToolbar.new(@instance)
    end

    def windows
      @windows ||= DocEditorWindows.new(@instance)
    end
  end
end
