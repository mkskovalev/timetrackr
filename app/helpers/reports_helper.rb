module ReportsHelper
  def report_period_range(report)
    "#{format_utc_datetime(report.start_date)} - #{format_utc_datetime(report.end_date)}"
  end

  def filled_days_count(months_data)
    months_data.sum { |_, days| days.sum { |_, count| count.to_i } }
  end

  def day_color_by_status(status, date)
    if status == 1
      'violet-600'
    elsif status == 0 && date <= Time.current.to_date
      'gray-300'
    else
      'gray-100'
    end
  end
end