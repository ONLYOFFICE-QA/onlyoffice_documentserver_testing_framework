# frozen_string_literal: true

module OnlyofficeDocumentserverTestingFramework
  # Helper to handle password protected files
  module PasswordProtectedHelper
    # @return [String] xpath of password input
    def xpath_input_password
      '//div[@id="id-password-txt"]//input'
    end

    # @return [String] xpath of ok in protected file dialog
    def xpath_ok_password
      "#{xpath_input_password}/../../../../../..//button"
    end

    # Handle some more alert dialogs
    def handle_password_protection(password)
      return unless @instance.selenium.element_visible?(xpath_input_password)

      @instance.selenium.type_text(xpath_input_password, password)
      @instance.selenium.click_on_locator(xpath_ok_password)
    end
  end
end
