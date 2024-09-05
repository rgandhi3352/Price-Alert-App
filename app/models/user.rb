class User < ApplicationRecord
	has_secure_password

  has_many :alerts, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i , message: "Email Invalid"}
  validates :password, presence: true, on: :create

  def jwt_token
    JwtAuth.encode({ user_id: id })
  end

  def self.find_by_token(token)
    decoded_token = JwtAuth.decode(token)
    return unless decoded_token

    find(decoded_token[:user_id])
  end

  def can_create_alert?
    alerts.created.count < 10 # Example limit of 10 active alerts per user
  end
end
