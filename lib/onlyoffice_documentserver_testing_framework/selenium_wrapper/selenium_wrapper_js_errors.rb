# frozen_string_literal: true

# Module for working with selenium wrapper JavaScript Errors
module SeleniumWrapperJsErrors
  # @return [Array<String>] list of errors should be ignored
  def ignored_errors
    return @ignored_errors if @ignored_errors

    @ignored_errors = File.readlines("#{Dir.pwd}/lib/onlyoffice_documentserver_testing_framework"\
                                     '/selenium_wrapper/selenium_wrapper_js_errors'\
                                     '/ingored_errors.list')
                          .map(&:strip)
  end

  def error_ignored?(error_message)
    ignored_errors.any? { |word| error_message.include?(word) }
  end

  def console_errors
    severe_error = []
    @instance.webdriver.browser_logs.each do |log|
      severe_error << log.message if log.level.include?('SEVERE') && !error_ignored?(log.message)
    end
    severe_error
  end

  alias get_console_errors console_errors
  extend Gem::Deprecate
  deprecate :get_console_errors, :console_errors, 2025, 1

  def fail_if_console_error
    errors = get_console_errors
    return if errors.empty?

    @instance.webdriver.webdriver_error(Selenium::WebDriver::Error::JavascriptError,
                                        "There are some errors in the Web Console: #{errors}")
  end
end
