# Class for single entry of file in doc test site
# https://cloud.githubusercontent.com/assets/668524/13947979/935506a6-f02e-11e5-86f4-6903dfd6119e.png
class DocTestSiteFileListEntry
  attr_accessor :file_name
  attr_accessor :embedded_url
  # @return [String] Review mode url
  attr_accessor :review_mode_url
  # @return [String] Comment mode url
  attr_accessor :comment_mode_url
  # @return [String] Fill forms mode url
  attr_reader :fill_forms_mode_url
  # @return [String] Only fill forms mode url
  attr_reader :only_fill_forms_mode_url
  # @return [String] View mode url
  attr_accessor :view_mode_url

  def initialize(instance, xpath)
    @instance = instance
    @xpath_line = xpath
    @file_name = fetch_file_name
    @embedded_url = fetch_embedded_url
    @review_mode_url = fetch_review_mode_url
    @comment_mode_url = fetch_comment_mode_url
    @fill_forms_mode_url = fetch_fill_forms_mode_url
    @view_mode_url = fetch_view_mode_url
  end

  def ==(other)
    @file_name == other.file_name
  end

  # @return [String] name of file
  def fetch_file_name
    text = @instance.selenium.get_text("#{@xpath_line}/td/a[1]/span")
    OnlyofficeLoggerHelper.log("Got filename #{@xpath_line} name: #{text}")
    text
  end

  # @return [String] url on review mode
  def fetch_review_mode_url
    xpath_review = "#{@xpath_line}/td[4]/a"
    return nil unless @instance.selenium.element_present?(xpath_review)

    url = @instance.selenium.get_attribute(xpath_review, 'href')
    OnlyofficeLoggerHelper.log("Got review mode #{@xpath_line} url: #{url}")
    url
  end

  # @return [String] url on review mode
  def fetch_comment_mode_url
    xpath_comment = "#{@xpath_line}/td[5]/a"
    return nil unless @instance.selenium.element_present?(xpath_comment)

    url = @instance.selenium.get_attribute(xpath_comment, 'href')
    OnlyofficeLoggerHelper.log("Got comment mode #{@xpath_line} url: #{url}")
    url
  end

  # @return [String] url on fill forms mode
  def fetch_fill_forms_mode_url
    xpath_comment = "#{@xpath_line}/td[6]/a"
    return nil unless @instance.selenium.element_present?(xpath_comment)

    url = @instance.selenium.get_attribute(xpath_comment, 'href')
    OnlyofficeLoggerHelper.log("Got fill forms mode #{@xpath_line} url: #{url}")
    url
  end

  # @return [String] url on fill forms mode
  def fetch_only_fill_forms_mode_url
    link_xpath = "#{@xpath_line}/td[7]/a"
    return nil unless @instance.selenium.element_present?(link_xpath)

    url = @instance.selenium.get_attribute(link_xpath, 'href')
    OnlyofficeLoggerHelper.log("Got only fill forms mode #{@xpath_line} url: #{url}")
    url
  end

  # @return [String] url on viewer mode
  def fetch_view_mode_url
    xpath_comments = "#{@xpath_line}/td[8]/a"
    return nil unless @instance.selenium.element_present?(xpath_comments)

    url = @instance.selenium.get_attribute(xpath_comments, 'href')
    OnlyofficeLoggerHelper.log("Got view mode #{@xpath_line} url: #{url}")
    url
  end

  # @return [String] url on embedded file
  def fetch_embedded_url
    url = @instance.selenium.get_attribute("#{@xpath_line}/td[10]/a", 'href')
    OnlyofficeLoggerHelper.log("Got embedded #{@xpath_line} url: #{url}")
    url
  end
end
