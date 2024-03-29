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

  it 'file_id_by_name return nil for unknown file' do
    expect(instance.integration_example_api.file_data('/foo')).to be_nil
  end

  it 'file_id_by_name return id for known file' do
    uploaded_name = instance.integration_example_api.upload_file(file)
    expect(instance.integration_example_api.file_data(uploaded_name)).to be_a(Hash)
  end

  it 'delete_file can delete uploaded file' do
    uploaded_name = instance.integration_example_api.upload_file(file)
    instance.integration_example_api.delete_file(uploaded_name)
    expect(instance.integration_example_api.file_data(uploaded_name)).to be_nil
  end

  it 'file with utf-8 name can be deleted' do
    utf_8_name = "#{Dir.pwd}/spec/data/Pasiones Mediterráneas.txt"
    uploaded_name = instance.integration_example_api.upload_file(utf_8_name)
    instance.integration_example_api.delete_file(uploaded_name)
    expect(instance.integration_example_api.file_data(uploaded_name)).to be_nil
  end
end
