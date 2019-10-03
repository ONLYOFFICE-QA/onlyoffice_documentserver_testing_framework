require 'spec_helper'

describe DocTestSiteFunctions do
  it '#language_list_options is correct' do
    instance = OnlyofficeDocumentserverTestingFramework::TestInstanceDocs.new
    instance.webdriver.open('http://localhost')
    instance.doc_service_welcome.go_to_example
    expect(instance.doc_test_functions.language_list_options).to eq(DocTestSiteFunctions::SUPPORTED_LANGUAGES)
  end
end
