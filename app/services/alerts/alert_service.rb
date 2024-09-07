module Alerts
  class AlertService
    PER_PAGE = 10
    def initialize(user)
      @user = user
    end

    def create_alert(target_price)
      return 'Maximum number of alerts reached' unless @user.can_create_alert?

      alert = @user.alerts.new(target_price: target_price)
      if alert.save
        Rails.cache.delete_matched("user_#{@user.id}_alerts*")
        Rails.cache.delete('created_alerts')
        { success: true, alert: alert }
      else
        { success: false, errors: alert.errors.full_messages }
      end
    end

    def delete_alert(alert_id)
      alert = @user.alerts.find_by(id: alert_id)
      return { success: false, error: 'Alert not found' } unless alert

      alert.update(status: :deleted)
      Rails.cache.delete_matched("user_#{@user.id}_alerts*")
      Rails.cache.delete('created_alerts')
      { success: true }
    end

    def fetch_alerts(status: nil, page: 1)
      cache_key = "user_#{@user.id}_alerts_page_#{params[:page]}_status_#{params[:status]}"

      alerts = Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
        scoped_alerts = @user.alerts.where(status: status || [:created, :triggered])
        scoped_alerts.page(page).per(10)
      end
      { alerts: alerts, total_pages: alerts.total_pages }
    end
  end
end
