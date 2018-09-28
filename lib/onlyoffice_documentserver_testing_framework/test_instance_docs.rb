require_relative 'test_instance_docs/common_editor/editor_windows'
require_relative 'test_instance_docs/doc_editor'

module OnlyofficeDocumentserverTestingFramework
  class TestInstanceDocs
    attr_accessor :selenium
    alias webdriver selenium

    def initialize(instance)
      @instance = instance
    end

    def doc_editor
      @doc_editor ||= DocEditor.new(self)
    end
  end
end