module PriceAlert
  class MainApi < Grape::API
    default_format :json
    format :json
    # prefix :api

    helpers do
      def permitted_params
        @permitted_params ||= declared(params, include_missing: false)
      end
    end
    mount ::PriceAlert::User
    mount ::PriceAlert::Alerts

  # Mount other APIs here if needed
  end
end