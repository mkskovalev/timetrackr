class UserMailer < ApplicationMailer
  def weekly_report(user, report)
    @user = user
    @report = report
    @start_date = report[:start_date]
    @end_date = report[:end_date]

    subject = I18n.t(
      'user_mailer.weekly_report.subject',
      start_date: @start_date.strftime('%d.%m.%Y'),
      end_date: @end_date.strftime('%d.%m.%Y'), 
      locale: user.locale
    )

    mail(to: @user.email, subject: subject)
  end
end