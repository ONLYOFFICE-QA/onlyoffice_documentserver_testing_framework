# frozen_string_literal: true

require 'spec_helper'

describe DocTestSiteFunctions, '#language_list_options' do
  it '#language_list_options is correct' do
    instance = OnlyofficeDocumentserverTestingFramework::TestInstanceDocs.new
    instance.webdriver.open('http://localhost')
    instance.doc_service_welcome.go_to_example
    a = instance.doc_test_functions.language_list_options
    a.each do |b|
      puts b
    end
    expect(instance.doc_test_functions.language_list_options).to eq(described_class.supported_languages)
  end
end
