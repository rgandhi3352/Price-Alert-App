class UserMailer < ApplicationMailer
	default from: 'rgandhi3352@gmail.com'

  def alert_notification(user, alert)
    @user = user
    @alert = alert
    mail(to: @user.email, subject: 'Price Alert Notification')
  end
end
