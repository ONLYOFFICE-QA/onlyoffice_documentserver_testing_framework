require_relative 'test_instance_docs/common_editor/editor_windows'
require_relative 'test_instance_docs/doc_editor'

module OnlyofficeDocumentserverTestingFramework
  class TestInstanceDocs
    def doc_editor
      @doc_editor ||= DocEditor.new(self)
    end
  end
end