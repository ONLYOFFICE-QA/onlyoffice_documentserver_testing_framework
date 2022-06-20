# frozen_string_literal: true

require_relative 'selenium_wrapper/selenium_wrapper_exceptions'
require_relative 'selenium_wrapper/selenium_wrapper_js_errors'
module OnlyofficeDocumentserverTestingFramework
  # Module for handle selenium with frames and some other methods
  module SeleniumWrapper
    include SeleniumWrapperJsErrors

    # Main wrapper function
    # @param name [Symbol] function to call
    # @param arguments [Hash] list of arguments
    # @return [Object] result of method
    def selenium_functions(name, *arguments, **options)
      select_frame do
        @instance.selenium.send name, *arguments, **options
      end
    end

    # Select actual frame of Editor
    def select_frame
      count_of_frame = @count_of_frame ? frame_count_addition : @instance.management.xpath_iframe_count
      xpath_of_frame = @xpath_of_frame || @instance.management.xpath_iframe
      @instance.selenium.select_frame xpath_of_frame, count_of_frame
      value = yield
      fail_if_console_error
      @instance.selenium.select_top_frame
      value
    end

    # @return [Integer] frame count with addition
    def frame_count_addition
      @count_of_frame + @instance.management.xpath_iframe_count - 1
    end

    # This method return true if xpath visible on the web page
    # @param[String] xpath
    # @return [Boolean]
    def visible?(xpath)
      selenium_functions :element_visible?, xpath
    end

    alias element_visible? visible?
    alias element_present_and_visible? visible?

    # This method click over button by xpath
    # @param[String] xpath
    def click_on_button(xpath)
      selenium_functions :click_on_locator, xpath
    end

    # This method return true if button pressed
    # @param[String] xpath
    # @return [Boolean]
    def button_pressed?(xpath)
      selenium_functions(:get_attribute, xpath, 'class').include?('active')
    end

    alias button_active? button_pressed?

    # This method return true if button disabled
    # @param[String] xpath
    # @return [Boolean]
    def button_disabled?(xpath)
      selenium_functions(:get_attribute, xpath, 'class').include?('disabled')
    end

    # @param xpath [String] xpath of menu
    # @return [True, False] if menu active
    def button_menu_active?(xpath)
      selenium_functions(:get_attribute, xpath, 'class').include?('menu-active')
    end

    # This method return true if button menu open
    # @param[String] xpath
    # @return [Boolean]
    def button_menu_open?(xpath)
      element_visible = visible?(xpath)
      element_visible = selenium_functions(:get_attribute, xpath, 'class').include?('open') if element_visible
      element_visible
    end

    # Click on one of several displayed
    # @param xpath [String] xpath to click
    # @return [nil]
    def click_on_of_several_by_display_button(xpath)
      selenium_functions :click_on_one_of_several_by_display, xpath
    end

    # Wait to element to appear and click
    # @param xpath [String] xpath to click
    # @return [nil]
    def click_on_displayed_button(xpath)
      selenium_functions :wait_element, xpath
      selenium_functions :click_on_displayed, xpath
    end

    # Is line enabled
    # @param xpath [String] xpath to check
    # @return [True, False]
    def line_enabled?(xpath)
      selenium_functions :element_visible?, xpath
    end

    # Is line checked
    # @param xpath [String] xpath to check
    # @return [True, False]
    def line_checked?(xpath)
      selenium_functions(:get_attribute, xpath, 'class').include?('checked')
    end

    # Is menu disabled
    # @param xpath [String] xpath to check
    # @return [True, False]
    def menu_disabled?(xpath)
      selenium_functions(:get_attribute, xpath, 'class').include?('disabled')
    end

    # Remove element
    # @param xpath [String] xpath to remove
    # @return [nil]
    def remove_element(xpath)
      selenium_functions :remove_element, xpath
    end

    # Get attribute
    # @param xpath [String] xpath to get attribute
    # @param attribute [String] attribute to get
    # @return [String] result of get attribute
    def get_attribute(xpath, attribute)
      selenium_functions :get_attribute, xpath, attribute
    end
  end
end
