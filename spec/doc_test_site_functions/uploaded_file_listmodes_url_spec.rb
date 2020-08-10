# frozen_string_literal: true

require 'spec_helper'

describe DocTestSiteFunctions,
         '#uploaded_file_list modes' do
  it 'fill form url is correct' do
    instance = OnlyofficeDocumentserverTestingFramework::TestInstanceDocs.new
    instance.webdriver.open('http://localhost')
    instance.doc_service_welcome.go_to_example
    instance.doc_test_functions.open_sample_document(:document, wait_to_load: false)
    instance.webdriver.choose_tab(2)
    instance.webdriver.close_tab
    instance.doc_test_functions.reload
    fill_form_url = instance.doc_test_functions.uploaded_file_list[0].fill_forms_mode_url
    expect(fill_form_url).to include('mode=fillForms')
  end
end
