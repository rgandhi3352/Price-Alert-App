module PriceAlert
  class Alerts < Grape::API
    USER_CACHE_KEY = 'user_cache'.freeze
    format :json

    before do
      authenticate_request!
    end

    helpers do
      def current_user
        token = request.headers['Authorization']
        @current_user ||= fetch_user_from_cache(token) || ::User.find_by_token(token)
      end

      def authenticate_request!
        token = request.headers['Authorization']
        error!('Unauthorized', 401) unless current_user
        cache_user(current_user, token)
        current_user
      end

      def cache_user(user, token)
        $redis.set("#{USER_CACHE_KEY}_#{token}", user.to_json)
        $redis.expire("#{USER_CACHE_KEY}_#{token}", 1.hour.to_i) # Adjust expiration as needed
      end

      def fetch_user_from_cache(token)
        user_data = $redis.get("#{USER_CACHE_KEY}_#{token}")
        return unless user_data

        ::User.new(JSON.parse(user_data))
      end
    end

    resource :alerts do
      desc 'Create an alert'
      params do
        requires :target_price, type: Float
      end
      post :create do
        service = ::Alerts::AlertService.new(current_user)
        result = service.create_alert(params[:target_price])

        if result[:success]
          { status: 'Alert created', alert: result[:alert] }
        else
          error!({ error: result[:errors] }, 422)
        end
      end

      desc 'Delete an alert'
      params do
        requires :id, type: Integer
      end
      delete :delete do
        service = ::Alerts::AlertService.new(current_user)
        result = service.delete_alert(params[:id])

        if result[:success]
          { status: 'Alert deleted' }
        else
          error!({ error: result[:error] }, 404)
        end
      end

      desc 'Fetch all alerts'
      params do
        optional :status, type: String, values: ["created", "triggered", "deleted"], desc: "Status of Alert"
        optional :page, type: Integer, default: 1
      end
      get do
        service = ::Alerts::AlertService.new(current_user)
        alerts = service.fetch_alerts(status: params[:status], page: params[:page])

        { success: true, alerts: alerts }
      end
    end
  end
end
