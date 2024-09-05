Rails.application.config.after_initialize do
  manager = PriceAlertManager.new
  manager.start_services
end