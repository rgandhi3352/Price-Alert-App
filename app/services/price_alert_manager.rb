class PriceAlertManager
  # Start both services in separate threads
  def start_services
    Thread.new { PriceCheckService.new }
    Thread.new { PriceUpdateSubscriber.new }
  end
end