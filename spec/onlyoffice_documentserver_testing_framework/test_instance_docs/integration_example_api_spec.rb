# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeDocumentserverTestingFramework::TestInstanceDocs,
         '#integration_example_api' do
  let(:instance) { described_class.new(doc_server_base_url: 'http://localhost') }

  it 'files list can be return an array' do
    expect(instance.integration_example_api.files).to be_a(Array)
  end
end
