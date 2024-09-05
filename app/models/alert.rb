class Alert < ApplicationRecord
  belongs_to :user

  before_validation :set_alert_type, if: -> { target_price.present? }

  enum status: { created: 0, triggered: 1, deleted: 2 }
  enum coin: { btc: 0 }

  validates :target_price, presence: true, numericality: { greater_than: 0 }
  validates :alert_type, presence: true

  private

  def set_alert_type
    current_price = BitcoinPriceService.fetch_current_price

    if current_price.present?
      self.alert_type = if current_price < target_price
                          'above'
                        else
                          'below'
                        end
    end
  end
end