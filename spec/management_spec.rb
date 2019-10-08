# frozen_string_literal: true

require 'spec_helper'

describe 'Management' do
  it 'correclty waiting to load of page with document' do
    instance = OnlyofficeDocumentserverTestingFramework::TestInstanceDocs.new
    instance.webdriver.open('https://localhost')
    instance.doc_service_welcome.go_to_example
    instance.doc_test_functions.open_sample_document
    expect(instance.management.wait_for_operation_with_round_status_canvas).to be_truthy
  end
end
