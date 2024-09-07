class AlertTriggerService
  def initialize(alert)
    @alert = alert
  end

  def trigger
    @alert.update(status: :triggered)
    Rails.cache.delete('created_alerts')
    Rails.cache.delete_matched("user_#{@alert.user_id}_alerts*")
    SendAlertEmailWorker.perform_async(@alert.id)
  end
end