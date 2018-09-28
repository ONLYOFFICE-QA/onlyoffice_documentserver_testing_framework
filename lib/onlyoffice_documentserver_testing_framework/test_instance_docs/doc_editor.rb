require_relative 'doc_editor/doc_editor_windows'

module OnlyofficeDocumentserverTestingFramework
# Class for all Doc Editor actions
  class DocEditor
    def initialize(instance)
      @instance = instance
    end

    def windows
      @windows ||= DocEditorWindows.new(@instance)
    end
  end
end
