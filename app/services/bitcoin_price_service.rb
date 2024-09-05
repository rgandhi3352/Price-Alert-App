require 'net/http'
require 'json'

class BitcoinPriceService
  API_URL = 'https://api.coingecko.com/api/v3/coins/bitcoin'

  def self.fetch_current_price
    uri = URI("#{API_URL}?localization=false")
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    data['market_data']['current_price']['usd']
  rescue StandardError => e
    Rails.logger.error "Failed to fetch Bitcoin price: #{e.message}"
    nil
  end
end