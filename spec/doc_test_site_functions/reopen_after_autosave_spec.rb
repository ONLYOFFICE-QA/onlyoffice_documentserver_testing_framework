# frozen_string_literal: true

require 'spec_helper'

describe DocTestSiteFunctions, '#reopen_after_autosave' do
  it 'reopen_after_autosave works correctly' do
    instance = OnlyofficeDocumentserverTestingFramework::TestInstanceDocs.new(docserver_base_url: 'http://localhost')
    instance.go_to_base_url
    instance.doc_service_welcome.go_to_example
    instance.doc_test_functions.open_sample_document
    instance.doc_test_functions.reopen_after_autosave
    expect(instance.spreadsheet_editor.top_toolbar.users.count).to eq(1)
  end
end
