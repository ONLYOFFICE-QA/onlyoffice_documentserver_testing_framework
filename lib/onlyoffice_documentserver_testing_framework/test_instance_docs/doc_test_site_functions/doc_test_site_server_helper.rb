# Helper method to fetch server url
module DocTestSiteServerHelper
  # @return [String] url of docserver
  def fetch_docserverserver_url(example_url)
    page_data = URI.parse(example_url).open.read
    html_doc = Nokogiri::HTML(page_data)
    load_scripts_data = html_doc.xpath('//*[@id="loadScripts"]')
    return nil if load_scripts_data.empty?

    script_html = load_scripts_data.attr('data-docs')
    server_from_cache_script_html(script_html)
  rescue RuntimeError => e
    OnlyofficeLoggerHelper.log("Failed to fetch_docserverserver_url with #{e}")
    nil
  end

  private

  def server_from_cache_script_html(url)
    uri = URI(url)
    "#{uri.scheme}://#{uri.host}:#{uri.port}"
  end
end
