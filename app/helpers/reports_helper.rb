module ReportsHelper
  def report_period_range(report)
    "#{format_utc_datetime(report.start_date)} - #{format_utc_datetime(report.end_date)}"
  end
end