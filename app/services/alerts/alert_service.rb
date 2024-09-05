module Alerts
  class AlertService
    PER_PAGE = 10
    def initialize(user)
      @user = user
    end

    def create_alert(target_price)
      clear_cache
      return 'Maximum number of alerts reached' unless @user.can_create_alert?

      alert = @user.alerts.new(target_price: target_price)
      if alert.save
        { success: true, alert: alert }
      else
        { success: false, errors: alert.errors.full_messages }
      end
    end

    def delete_alert(alert_id)
      alert = @user.alerts.find_by(id: alert_id)
      return { success: false, error: 'Alert not found' } unless alert

      alert.update(status: :deleted)
      clear_cache
      { success: true }
    end

    def fetch_alerts(status: nil, page: 1)
      cache_key = "user:#{@user.id}:alerts:status:#{status}:page:#{page}"
      cached_alerts = $redis.get(cache_key)

      if cached_alerts
        JSON.parse(cached_alerts)
      else
        alerts = @user.alerts.where(status: status || [:created, :triggered])
        paginated_alerts = alerts.page(page).per(PER_PAGE)
        $redis.set(cache_key, paginated_alerts.to_json)
        $redis.expire(cache_key, 10.minutes.to_i)
        paginated_alerts
      end
    end

    private

    def clear_cache
      $redis.keys("user:#{@user.id}:alerts:*").each { |key| $redis.del(key) }
    end
  end
end
