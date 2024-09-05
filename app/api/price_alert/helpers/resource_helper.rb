module PriceAlert
  module Helpers
    module ResourceHelper
      extend Grape::API::Helpers

      # Helper to handle declared parameters safely
      def safe_params
        declared(params, include_missing: false)
      end

      # Other common methods can go here
    end
  end
end
