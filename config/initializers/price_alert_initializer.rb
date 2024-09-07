Rails.application.config.after_initialize do
  if ENV['APP_ENV'] == 'web'
    manager = PriceAlertManager.new
    manager.start_services
  end
end