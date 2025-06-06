# frozen_string_literal: true

module OnlyofficeDocumentserverTestingFramework
  # Meta class to describe editors tabs
  class EditorTab
    include SeleniumWrapper

    def initialize(instance, tab_xpath: nil, tab_name: 'Default tab name')
      @instance = instance
      @xpath_insert_tab = tab_xpath
      @tab_name = tab_name
    end

    # @return [True, False] is tab present
    def present?
      result = visible?(@xpath_insert_tab)
      OnlyofficeLoggerHelper.log("#{@tab_name} Tab present?: #{result}")
      result
    end

    # @return [True, False] if this tab opened
    def active?
      active = get_attribute(@xpath_insert_tab, 'class').include?('active')
      OnlyofficeLoggerHelper.log("#{@tab_name} Tab active?: #{active}")
      active
    end

    # Click on tab
    # @return [Nothing]
    def click
      click_on_button(@xpath_insert_tab)
      OnlyofficeLoggerHelper.log("Clicked on #{@tab_name} Tab")
      sleep 2 # timeout for tab animation
    end

    # Double click on tab
    # @return [Nothing]
    def double_click
      selenium_functions(:double_click, @xpath_insert_tab)
      OnlyofficeLoggerHelper.log("Double Clicked on #{@tab_name} Tab")
      sleep 2 # need time to toolbar to hide
    end

    # Open current tab
    # @param [Boolean] to_open open or close this tab
    # @return [Void]
    # rubocop disable to not change interface of public method
    # rubocop:disable Style/OptionalBooleanParameter
    def open(to_open = true)
      click if to_open != active?
      close_tooltips
    end

    # Close tooltips
    # @return [Nothing]
    def close_tooltips
      click_on_button(close_tooltip_xpath) while visible?(tooltip_xpath)
    end
    # rubocop:enable Style/OptionalBooleanParameter

    private

    # @return [String] xpath to tooltip
    def tooltip_xpath
      "//div[contains(@class, 'synch-tip-root')]"
    end

    # @return [String] xpath to close button in tooltip
    def close_tooltip_xpath
      "#{tooltip_xpath}//div[@class = 'btn-div' or @class = 'close']"
    end
  end
end
