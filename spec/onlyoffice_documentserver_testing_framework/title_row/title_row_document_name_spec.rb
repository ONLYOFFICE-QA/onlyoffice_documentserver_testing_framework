# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeDocumentserverTestingFramework::TitleRow,
         '#document_name' do
  let(:instance) { OnlyofficeDocumentserverTestingFramework::TestInstanceDocs.new }

  before do
    instance.webdriver.open('http://localhost')
    instance.doc_service_welcome.go_to_example
    instance.doc_test_functions.open_sample_document
    instance.management.wait_for_operation_with_round_status_canvas
  end

  after do
    instance.webdriver.quit
  end

  it 'document_name by default has example name' do
    expect(instance.doc_editor.top_toolbar.title_row.document_name).to include('new')
  end

  it 'document_name by default has docx extension' do
    expect(instance.doc_editor.top_toolbar.title_row.document_name).to include('docx')
  end

  it 'document_name can be returned without extension' do
    expect(instance.doc_editor.top_toolbar.title_row.document_name(with_extension: false)).not_to include('docx')
  end
end
