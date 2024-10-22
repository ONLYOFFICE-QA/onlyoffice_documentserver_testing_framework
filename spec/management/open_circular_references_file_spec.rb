# frozen_string_literal: true

require 'spec_helper'

describe 'Management', '#open_circular_references_file' do
  let(:instance) { OnlyofficeDocumentserverTestingFramework::TestInstanceDocs.new }

  before do
    file = "#{Dir.pwd}/spec/data/circular_references.xlsx"
    instance.webdriver.open('http://localhost')
    instance.doc_service_welcome.go_to_example
    instance.doc_test_functions.upload_file(file)
  end

  it 'circular references file can be opened' do
    instance.doc_test_functions.open_file_in_editor
    expect(instance.management.wait_for_operation_with_round_status_canvas).to be_truthy
  end
end
