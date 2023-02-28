# frozen_string_literal: true

require 'spec_helper'

describe 'Management', '#open_update_links_file' do
  let(:instance) { OnlyofficeDocumentserverTestingFramework::TestInstanceDocs.new }

  before do
    file = "#{Dir.pwd}/spec/data/external_link_destination.xlsx"
    instance.webdriver.open('http://localhost')
    instance.doc_service_welcome.go_to_example
    instance.doc_test_functions.upload_file(file)
  end

  it 'file with links to update can be opened' do
    instance.doc_test_functions.open_file_in_editor
    expect(instance.management.wait_for_operation_with_round_status_canvas).to be_truthy
  end

  it 'update file with links' do
    instance.management.to_update = true
    instance.doc_test_functions.open_file_in_editor
    expect(instance.management.wait_for_operation_with_round_status_canvas).to be_truthy
  end
end
