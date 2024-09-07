class PriceUpdateSubscriber
  CHANNEL = 'btc_price_updates'

  def initialize
    start_listening
  end

  def start_listening
    # puts "Subscribed to #{CHANNEL} for price updates..."
    Thread.new do
      $redis.subscribe(CHANNEL) do |on|
        on.message do |channel, message|
          data = JSON.parse(message)
          handle_price_update(data)
        end
      end
    end
  end

  private

  def handle_price_update(data)
    # puts "Received price update: #{data['price']} for #{data['symbol']} at #{Time.at(data['timestamp'])}"
    alerts = Rails.cache.fetch('created_alerts', expires_in: 5.minutes) do
      ::Alert.where(status: 0).to_a
    end
    alerts.each do |alert|
      case alert.alert_type
      when 'above'
        if data['price'].to_f >= alert.target_price
          ::AlertTriggerService.new(alert).trigger
        end
      when 'below'
        if data['price'].to_f <= alert.target_price
          ::AlertTriggerService.new(alert).trigger
        end
      end
    end
  end
end