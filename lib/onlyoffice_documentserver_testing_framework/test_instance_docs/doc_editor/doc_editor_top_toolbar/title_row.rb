# frozen_string_literal: true

module OnlyofficeDocumentserverTestingFramework
  # Module for description of title row
  # https://user-images.githubusercontent.com/668524/114713496-db20f900-9d39-11eb-8adc-8ed79a8e6c12.png
  class TitleRow
    include SeleniumWrapper

    def initialize(instance)
      @instance = instance
      @xpath_document_name = '//*[(@id="rib-doc-name") or (@id="title-doc-name")]'
    end

    # @param [Boolean] with_extension be included
    # @return [String] current document name
    def document_name(with_extension: true)
      doc_name = raw_document_name
      doc_name.chop! if document_unsaved?(doc_name)
      doc_name = File.basename(doc_name, '.*') unless with_extension
      doc_name
    end

    # Check if current document unsaved
    # @param [String] name of file
    # @return [Boolean] result of check
    def document_unsaved?(name = nil)
      name[-1] == '*'
    end

    private

    # @return [String] raw data from document name
    def raw_document_name
      text = selenium_functions(:get_text_by_js, @xpath_document_name)
      OnlyofficeLoggerHelper.log("Get document name from header: #{text}")
      text
    end
  end
end
