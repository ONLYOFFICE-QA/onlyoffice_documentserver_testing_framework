# frozen_string_literal: true

require 'spec_helper'

describe 'Management' do
  let(:instance) { OnlyofficeDocumentserverTestingFramework::TestInstanceDocs.new }

  before do
    instance.webdriver.open('http://localhost')
    instance.doc_service_welcome.go_to_example
    instance.doc_test_functions.open_sample_document
  end

  it 'correclty waiting to load of page with document' do
    expect(instance.management.wait_for_operation_with_round_status_canvas).to be_truthy
  end

  it 'no console errors in opened document' do
    instance.management.wait_for_operation_with_round_status_canvas
    expect(instance.management.console_errors).to be_empty
  end
end
