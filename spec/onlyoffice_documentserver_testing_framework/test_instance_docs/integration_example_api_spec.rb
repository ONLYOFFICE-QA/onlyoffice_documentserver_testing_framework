# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeDocumentserverTestingFramework::TestInstanceDocs,
         '#integration_example_api' do
  let(:instance) { described_class.new(doc_server_base_url: 'http://localhost') }
  let(:file) { "#{Dir.pwd}/spec/data/image_js_error.docx" }

  it 'files list can be return an array' do
    expect(instance.integration_example_api.files).to be_a(Array)
  end

  it 'uploading file will return it file name' do
    uploaded_name = instance.integration_example_api.upload_file(file)
    expect(uploaded_name).to start_with(File.basename(file, '.*'))
  end

  it 'you can upload same file several times and got different names' do
    first_name = instance.integration_example_api.upload_file(file)
    second_name = instance.integration_example_api.upload_file(file)
    expect(first_name).not_to eq(second_name)
  end
end
