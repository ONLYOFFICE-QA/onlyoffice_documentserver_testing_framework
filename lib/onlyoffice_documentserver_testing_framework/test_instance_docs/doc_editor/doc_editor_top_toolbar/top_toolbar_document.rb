# frozen_string_literal: true

module OnlyofficeDocumentserverTestingFramework
  # More methods for working with top toolbar of document
  class TopToolbarDocument
    include SeleniumWrapper

    def initialize(instance)
      @instance = instance
      @xpath_document_name = '//*[(@id="rib-doc-name") or (@id="title-doc-name")]'
    end

    # @return [String] name of the document
    def document_name
      # TODO: use `get_text` before `get_text_by_js`
      #   as soon as https://bugzilla.onlyoffice.com/show_bug.cgi?id=45981 resolved
      # If top toolbar is hidden - cannot get text by WebDriver, use js instead
      text = selenium_functions(:get_text_by_js, @xpath_document_name)
      OnlyofficeLoggerHelper.log("Get document name from header: #{text}")
      text
    end
  end
end
