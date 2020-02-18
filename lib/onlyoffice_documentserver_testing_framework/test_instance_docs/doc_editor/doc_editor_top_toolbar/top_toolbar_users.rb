# frozen_string_literal: true

module OnlyofficeDocumentserverTestingFramework
  # Class for getting info about share and users
  # https://user-images.githubusercontent.com/668524/28920497-d444b674-785a-11e7-9254-2f46d4e95261.png
  class TopToolbarUsers
    include SeleniumWrapper

    def initialize(instance)
      @instance = instance
      @xpath_button = '//*[@id="tlb-box-users"]'
      @xpath_count = "#{@xpath_button}/div/label"
    end

    # @return [True, False] is button present
    def present?
      visible = visible?(@xpath_button)
      OnlyofficeLoggerHelper.log("Button present: #{visible}")
      visible
    end

    # @return [Integer] count of users
    def count
      return 1 unless present?

      count = selenium_functions(:get_text, @xpath_count)
      count = 1 if count == '+'
      OnlyofficeLoggerHelper.log("User count: #{count}")
      count.to_i
    end
  end
end
