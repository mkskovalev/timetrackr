class WeeklyReportJob < ApplicationJob
  queue_as :default

  def perform
    end_date = Time.now.beginning_of_week - 1.second
    start_date = end_date.beginning_of_week

    prev_end_date = start_date - 1.second
    prev_start_date = prev_end_date.beginning_of_week

    User.joins(:subscriptions).where(
      subscriptions: { subscription_type: 'weekly_report' }
    ).where(
      'subscriptions.email = true OR subscriptions.telegram = true'
    ).distinct.find_each do |user|
      report = ReportsService.generate_weekly_report(user, start_date, end_date, prev_start_date, prev_end_date)

      weekly_report_subscription = user.subscriptions.find_by(subscription_type: 'weekly_report')

      if weekly_report_subscription&.email
        UserMailer.weekly_report(user, report).deliver_later
      end

      puts weekly_report_subscription.inspect
      if weekly_report_subscription&.telegram
        TelegramService.send_weekly_report(user, report, start_date, end_date)
      end
    end
  end
end
