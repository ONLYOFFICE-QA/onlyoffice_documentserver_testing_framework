# frozen_string_literal: true

module OnlyofficeDocumentserverTestingFramework
  # Helper to handle password protected files on conversion step
  module PasswordProtectedConversionHelper
    # @return [String] xpath of password input
    def xpath_input_password
      '//input[@id="filePass"]'
    end

    # @return [String] xpath of enter button
    def xpath_enter_password
      '//div[@id="enterPass"]'
    end

    # @return [String] xpath of error message
    def xpath_password_error
      '//span[@class="errorPass"]'
    end

    # Waits until password is checked
    # @return [Nothing]
    def wait_to_check_password
      @instance.webdriver.wait_until(5) do
        !@instance.webdriver.get_attribute(@xpath_conversion_step, 'class').include?('current')
      end
    end

    # @return [Boolean] check if incorrect password warning is shown
    def incorrect_password_shown?
      @instance.selenium.element_visible?(xpath_password_error)
    end

    # Handle password block
    def handle_password_protection(password)
      @instance.selenium.type_text(xpath_input_password, password)
      @instance.selenium.click_on_locator(xpath_enter_password)
      wait_to_check_password
      @instance.webdriver.webdriver_error("Cannot open file with password: `#{password}`") if incorrect_password_shown?
      OnlyofficeLoggerHelper.log('Entered password')
    end
  end
end
