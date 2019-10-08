# frozen_string_literal: true

# Page for describing healthcheck page
class HealthcheckPage
  def initialize(instance)
    @instance = instance
  end

  # @return [String] status of healthcheck on page
  def status
    current_status = @instance.webdriver.get_text('//body')
    OnlyofficeLoggerHelper.log("Current status of healthcheck is: #{current_status}")
    current_status
  end
end
