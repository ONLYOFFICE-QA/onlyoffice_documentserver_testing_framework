# frozen_string_literal: true

require_relative 'doc_editor_windows/txt_options'

module OnlyofficeDocumentserverTestingFramework
  # Windows of Doc Editor
  class DocEditorWindows < EditorWindows
    def initialize(instance)
      @instance = instance
      super()
    end

    # @return [TxtOptions] widnow for txt options
    def txt_options
      @txt_options ||= TxtOptions.new(@instance)
    end
  end
end
