# frozen_string_literal: true

require 'spec_helper'

describe DocTestSiteFunctions, '#current_document_storage_url' do
  it '#current_document_storage_url can be downloaded' do
    instance = OnlyofficeDocumentserverTestingFramework::TestInstanceDocs.new
    instance.webdriver.open('https://doc-linux.teamlab.info')
    instance.doc_service_welcome.go_to_example
    instance.doc_test_functions.open_sample_document
    expect(instance.selenium.download(instance.doc_test_functions.current_document_storage_url)).to be_truthy
  end
end
