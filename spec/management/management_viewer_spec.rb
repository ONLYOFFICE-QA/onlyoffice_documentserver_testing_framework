# frozen_string_literal: true

require 'spec_helper'

describe 'Management', '#viewer?' do
  let(:instance) { OnlyofficeDocumentserverTestingFramework::TestInstanceDocs.new }

  before do
    file = "#{Dir.pwd}/spec/data/sample.docx"
    instance.webdriver.open('http://localhost')
    instance.doc_service_welcome.go_to_example
    instance.doc_test_functions.upload_file(file)
  end

  it 'viewer? return correct result for viewer mode' do
    instance.doc_test_functions.open_file_in_viewer
    instance.management.wait_for_operation_with_round_status_canvas
    expect(instance.management).to be_viewer
  end

  it 'viewer? return correct result for editor mode' do
    instance.doc_test_functions.open_file_in_editor
    instance.management.wait_for_operation_with_round_status_canvas
    expect(instance.management).not_to be_viewer
  end
end
