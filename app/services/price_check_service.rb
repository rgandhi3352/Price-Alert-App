class PriceCheckService
	CHANNEL = 'btc_price_updates'

	def initialize
		start_price_stream
  end

  def start_price_stream
    Thread.new do
      EM.run do
        websocket = Binance::WebSocket.new

        # Subscribe to real-time BTCUSDT trades
        websocket.trades!(%w[BTCUSDT]) do |stream_name, trade|
          on_trade(trade)
        end
      end
    end
  end

  private

  def on_trade(trade)
    price = trade[:p]
    symbol = trade[:s]

    # puts "Real-time Price: #{price} for #{symbol}"

    # Publish the price to the Redis channel
    publish_price_update(price, symbol)
  end

  # Publish price updates to Redis
  def publish_price_update(current_price, current_symbol)
    $redis.publish(CHANNEL, { symbol: current_symbol, price: current_price, timestamp: Time.now.to_i }.to_json)
  end
end