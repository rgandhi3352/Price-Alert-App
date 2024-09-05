Rails.application.routes.draw do
  mount PriceAlert::MainApi => '/api'
end
