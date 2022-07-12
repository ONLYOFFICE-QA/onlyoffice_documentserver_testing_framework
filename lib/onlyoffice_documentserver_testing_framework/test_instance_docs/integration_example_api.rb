# frozen_string_literal: true

require 'uri'
require 'net/http'

module OnlyofficeDocumentserverTestingFramework
  # Class for working with integration example api
  class IntegrationExampleApi
    # @return [String] url of api endpoint
    attr_reader :api_endpoint

    def initialize(instance, api_endpoint: "#{instance.doc_server_base_url}/example")
      @instance = instance
      @api_endpoint = remove_example_suffix(api_endpoint)
    end

    # @return [Array<Hash>] list of file on example
    def files
      url = "#{@api_endpoint}/files/"
      request = Net::HTTP::Get.new(url)
      response = http_from_url(url).request(request)
      JSON.parse(response.read_body)
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

    # Delete file on server by name
    # @param [String] file_name name of file to delete
    # @param [Integer] sleep_after_delete how much time to sleep after file delete
    #   sometimes it took time to delete this file and it cannot be checked by `file_data`
    #   method, since file will be not created but you get inside old file
    # @return [nil]
    def delete_file(file_name, sleep_after_delete: 3)
      raise 'File name is not found on server' unless file_data(file_name)

      url = URI::DEFAULT_PARSER.escape("#{@api_endpoint}/file?filename=#{file_name}")
      request = Net::HTTP::Delete.new(url)
      response = http_from_url(url).request(request)
      result = JSON.parse(response.read_body)
      sleep(sleep_after_delete)
      result
    end

    # Get file data by it's name
    # @param [String] name
    # @return [String, nil] id
    def file_data(name)
      files.each do |file|
        return file if file['title'] == name
      end
      nil
    end

    private

    def http_from_url(url)
      uri = URI(url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      http
    end

    # Check if example url need to be removed with
    # /example
    # For example test example may be on `http://100.100.100.100` host
    # or can be on `http://100.100.100.100/example` host
    # This method will detect which to use
    # @param [String] example_url via config
    # @return [String] example url with correct url
    def remove_example_suffix(example_url)
      without_suffix = example_url.gsub('/example', '')
      source = URI.parse(without_suffix).open.read
      return without_suffix if source.include?('John Smith')

      example_url
    rescue Errno::ECONNREFUSED, Errno::ENOENT, NoMethodError
      example_url
    end
  end
end
