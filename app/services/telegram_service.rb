require 'telegram/bot'

class TelegramService
  def self.send_weekly_report(user, report, start_date, end_date)
    return unless user.telegram_id

    I18n.with_locale(user.locale) do
      message = format_report_message(report, start_date, end_date)
      send_message(user.telegram_id, message)
    end
  end

  private

  def self.format_report_message(report, start_date, end_date)
    header = I18n.t('telegram_service.weekly_report.title') + "\n"
    header += I18n.t('telegram_service.weekly_report.period', start_date: start_date.strftime('%d.%m.%Y'), end_date: end_date.strftime('%d.%m.%Y')) + "\n\n"

    table = format_table(report)

    header + table
  end

  def self.format_table(report)
    # Columns width
    col1_width = 15
    col2_width = 10
    col3_width = 10

    # Table title
    table = "```\n"
    table += format_row(
      I18n.t('telegram_service.weekly_report.category'),
      I18n.t('telegram_service.weekly_report.time_spent'),
      I18n.t('telegram_service.weekly_report.change'),
      col1_width, col2_width, col3_width
    )
    table += "-" * (col1_width + col2_width + col3_width + 4) + "\n"  # Separator

    # Table data
    report[:categories].each do |category_name, data|
      table += format_row(category_name, data[:time_spent], format_percentage_change(data[:percentage_change]), col1_width, col2_width, col3_width)
    end

    table += "```"  # Closing the formatting with monospaced font
    table
  end

  def self.format_row(col1, col2, col3, col1_width, col2_width, col3_width)
    "#{col1.ljust(col1_width)} | #{col2.rjust(col2_width)} | #{col3.rjust(col3_width)}\n"
  end

  def self.format_percentage_change(num)
    arrow = num > 0 ? "🔼" : num < 0 ? "🔽" : ""
    "#{num}% #{arrow}"
  end

  def self.send_message(chat_id, text)
    token = Rails.application.credentials.telegram[Rails.env.to_sym][:api_token]
    retries ||= 0
    begin
      Telegram::Bot::Client.run(token) do |bot|
        bot.api.send_message(chat_id: chat_id, text: text, parse_mode: 'Markdown')
      end
    rescue Faraday::ConnectionFailed, Socket::ResolutionError => e
      retries += 1
      if retries < 3
        sleep(5)
        retry
      else
        Rails.logger.error("Failed to send message via Telegram: #{e.message}")
      end
    end
  end
end