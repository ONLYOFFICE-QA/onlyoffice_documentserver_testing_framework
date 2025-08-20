# frozen_string_literal: true

# Class defined CheckBox PageObject
class CheckBox
  include SeleniumWrapper
  attr_accessor :xpath, :count_of_frame, :xpath_of_frame

  # @param [Object] instance
  # @param [String (frozen)] xpath
  # @param [Hash] params
  def initialize(instance, xpath = '', params = {})
    @instance = instance
    @xpath = xpath_to_click(xpath)
    @count_of_frame = params.fetch(:count_of_frame, 1)
  end

  # @return [TrueClass, FalseClass]
  def checked?
    selenium_functions(:get_attribute, @xpath, 'class').include?('checked') ||
      selenium_functions(:computed_style, @xpath, ':before', 'content') == ''
  end

  # @return [Object]
  def uncheck
    set(false)
  end

  # @return [Object]
  def check
    set(true)
  end

  # Click on CheckBox
  # @return [Nothing]
  def click
    selenium_functions(:click_on_locator, @xpath)
    OnlyofficeLoggerHelper.log("Clicked on #{@xpath} checkbox")
  end

  # @param [TrueClass] value
  def set(value: true)
    click unless checked? == value
  end

  # @return [TrueClass, FalseClass]
  def enable?
    !selenium_functions(:get_attribute, "#{@xpath}/..", 'class').include?('disabled')
  end

  alias enabled? enable?

  private

  # @param [String] xpath of root of checkbox
  # @return [String] xpath to click on
  def xpath_to_click(xpath)
    "#{xpath}/label/label"
  end
end
