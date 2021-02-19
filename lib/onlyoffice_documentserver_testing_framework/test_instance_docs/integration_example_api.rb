# frozen_string_literal: true

require 'uri'
require 'net/http'

module OnlyofficeDocumentserverTestingFramework
  # Class for working with integration example api
  class IntegrationExampleApi
    def initialize(instance)
      @instance = instance
      @api_endpoint = "#{@instance.doc_server_base_url}/example"
    end

    # @return [Array<Hash>] list of file on example
    def files
      http_get("#{@api_endpoint}/files/")
    end

    # Upload file by it's path
    # @param [String] file_path
    # @return [String] name of uploaded file
    def upload_file(file_path)
      url = URI("#{@api_endpoint}/upload/")

      request = Net::HTTP::Post.new(url)
      form_data = [['uploadedFile', File.open(file_path)]]
      request.set_form(form_data, 'multipart/form-data')
      response = http_from_url(url).request(request)
      JSON.parse(response.read_body)['filename']
    end

    private

    def http_from_url(url)
      uri = URI(url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      http
    end

    def http_get(url)
      request = Net::HTTP::Get.new(url)
      response = http_from_url(url).request(request)
      JSON.parse(response.read_body)
    end
  end
end
