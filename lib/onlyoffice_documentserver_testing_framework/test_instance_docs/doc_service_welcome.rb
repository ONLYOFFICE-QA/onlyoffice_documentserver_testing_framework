# frozen_string_literal: true

# Class for describing Welcome page of test example
# https://cloud.githubusercontent.com/assets/668524/15577518/891848c8-2365-11e6-8a2a-af98618067b5.png
class DocServiceWelcome
  def initialize(instance)
    @instance = instance
    @xpath_test_example = '//a[contains(@href, "/example")]'
  end

  # Waiting for load of page
  # @return [Nothing]
  def wait_load
    @instance.webdriver.wait_until do
      opened?
    end
    sleep 1 # Additional wait for load
  end

  # @return [True, False] is welcome page opened
  def opened?
    result = @instance.selenium.element_present?(@xpath_test_example)
    OnlyofficeLoggerHelper.log("Current server is a Doc Service Welcome: #{result}")
    result
  end

  # Go to Test Example
  # @return [Nothing]
  def go_to_example
    wait_load
    @instance.selenium.wait_until_element_visible(@xpath_test_example)
    @instance.selenium.click_on_locator(@xpath_test_example)
    OnlyofficeLoggerHelper.log('Go to test example')
    @instance.doc_test_functions.wait_load
  end
end
