class AdminMailer < ApplicationMailer
  def new_user_registered(user)
    @user = user
    admin_email = Rails.application.credentials.dig(:admin, :email)
    mail(to: admin_email, subject: 'New user registered')
  end
end