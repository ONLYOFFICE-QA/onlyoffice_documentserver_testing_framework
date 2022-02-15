# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeDocumentserverTestingFramework::IntegrationExampleApi do
  test_instance = OnlyofficeDocumentserverTestingFramework::TestInstanceDocs.new
  it 'By default #api_endpoint is not empty' do
    expect(described_class.new(test_instance)
                          .api_endpoint).not_to be_empty
  end

  it '#api_endpoint could be changed in constructor' do
    custom_endpoint = 'http://localhost:1234/custom'
    expect(described_class.new(test_instance,
                               api_endpoint: custom_endpoint).api_endpoint)
      .to eq(custom_endpoint)
  end
end
