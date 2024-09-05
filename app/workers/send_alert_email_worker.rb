class SendAlertEmailWorker
  include Sidekiq::Worker

  def perform(alert_id)
    alert = ::Alert.find(alert_id)
    user = alert.user

    UserMailer.alert_notification(user, alert).deliver_now
  end
end