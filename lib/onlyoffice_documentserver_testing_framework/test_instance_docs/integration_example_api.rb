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

    private

    def http_get(url)
      uri = URI(url)

      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true if uri.scheme == 'https'

      request = Net::HTTP::Get.new(uri)

      response = https.request(request)
      JSON.parse(response.read_body)
    end
  end
end
