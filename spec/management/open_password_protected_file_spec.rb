# frozen_string_literal: true

require 'spec_helper'

describe 'Management', '#open_password_protected_file' do
  let(:instance) { OnlyofficeDocumentserverTestingFramework::TestInstanceDocs.new }

  before do
    file = "#{Dir.pwd}/spec/data/password_protected_111.xlsx"
    instance.webdriver.open('http://localhost')
    instance.doc_service_welcome.go_to_example
    instance.doc_test_functions.upload_file(file)
  end

  it 'password protected file can be opened' do
    instance.management.password = '111'
    instance.doc_test_functions.open_file_in_editor
    expect(instance.management.wait_for_operation_with_round_status_canvas).to be_truthy
  end

  it 'password protected file fail fast with incorrect password' do
    instance.management.password = 'incorrect_password'
    expect { instance.doc_test_functions.open_file_in_editor }
      .to raise_error(RuntimeError, /#{instance.management.password}/)
  end
end
