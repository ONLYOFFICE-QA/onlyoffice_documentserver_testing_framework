# frozen_string_literal: true

module OnlyofficeDocumentserverTestingFramework
  # Helper to close tooltips
  module TooltipHelper
    # Close tooltips
    # @return [Nothing]
    def close_tooltips
      count = tooltips_count
      count.times do |current_tooltip_number|
        click_on_button(close_tooltip_xpath(current_tooltip_number + 1)) while visible?(tooltip_xpath(current_tooltip_number + 1))
      end
    end

    # @return [Integer] count of opened tooltips
    def tooltips_count
      selenium_functions(:get_element_count, tooltip_root_xpath)
    end

    private

    def tooltip_root_xpath
      "//div[contains(@class, 'synch-tip-root')]"
    end

    # @return [String] xpath to tooltip
    def tooltip_xpath(number = 1)
      "(#{tooltip_root_xpath})[#{number}]"
    end

    # @return [String] xpath to close button in tooltip
    def close_tooltip_xpath(number = 1)
      "#{tooltip_xpath(number)}//div[@class = 'close']"
    end
  end
end
