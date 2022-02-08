# frozen_string_literal: true

require 'spec_helper'

describe DocTestSiteFunctions, '#reopen_after_autosave' do
  it 'reopen_after_autosave fails for document without any changes' do
    instance = OnlyofficeDocumentserverTestingFramework::TestInstanceDocs.new(doc_server_base_url: 'http://localhost')
    instance.go_to_base_url
    instance.doc_service_welcome.go_to_example
    instance.doc_test_functions.open_sample_document
    expect { instance.doc_test_functions.reopen_after_autosave }.to raise_error(/Wait until timeout/)
  end
end
