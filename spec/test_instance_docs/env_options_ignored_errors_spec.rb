# frozen_string_literal: true

require 'spec_helper'

describe 'TestInstanceDocs#env_options ignored errors' do
  let(:instance) { OnlyofficeDocumentserverTestingFramework::TestInstanceDocs.new }
  let(:exception_text) { 'server responded with a status of 404' }

  before do
    file = "#{Dir.pwd}/spec/data/image_js_error.docx"
    instance.webdriver.open('http://localhost')
    instance.doc_service_welcome.go_to_example
    instance.doc_test_functions.upload_file(file)
    instance.doc_test_functions.open_file_in_editor
  end

  it 'by default raising exception raise error in test' do
    expect { instance.doc_editor.top_toolbar.users.present? }
      .to raise_error(Selenium::WebDriver::Error::JavascriptError, /#{exception_text}/)
  end

  it 'if env option with same single exception is specified everything is fine' do
    ENV['ONLYOFFICE_DS_TESTING_OPTIONS'] = "{ \"IgnoredJSErrors\": [\"#{exception_text}\"]}"
    expect { instance.doc_editor.top_toolbar.users.present? }
      .not_to raise_error
  end

  it 'if env option with same exception and some other is specified and everything is fine' do
    ENV['ONLYOFFICE_DS_TESTING_OPTIONS'] = "{ \"IgnoredJSErrors\": [\"#{exception_text}\", \"exp2\"]}"
    expect { instance.doc_editor.top_toolbar.users.present? }
      .not_to raise_error
  end

  it 'if env option with several other exception' do
    ENV['ONLYOFFICE_DS_TESTING_OPTIONS'] = '{ "IgnoredJSErrors": ["exp1", "exp2"]}'
    expect { instance.doc_editor.top_toolbar.users.present? }
      .to raise_error(Selenium::WebDriver::Error::JavascriptError, /#{exception_text}/)
  end

  after do
    instance.webdriver.quit
  end
end
