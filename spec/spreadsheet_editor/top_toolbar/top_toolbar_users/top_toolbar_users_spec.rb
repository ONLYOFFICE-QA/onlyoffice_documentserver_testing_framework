# frozen_string_literal: true

require 'spec_helper'

describe 'Management' do
  let(:instance) { OnlyofficeDocumentserverTestingFramework::TestInstanceDocs.new }

  before do
    instance.webdriver.open('http://localhost')
    instance.doc_service_welcome.go_to_example
    instance.doc_test_functions.open_sample_document(:spreadsheet)
    instance.management.wait_for_operation_with_round_status_canvas
  end

  it 'default user button is not present' do
    expect(instance.spreadsheet_editor.top_toolbar.users).not_to be_present
  end

  it 'default user count is 1' do
    expect(instance.spreadsheet_editor.top_toolbar.users.count).to eq(1)
  end

  after do
    instance.webdriver.quit
  end
end
