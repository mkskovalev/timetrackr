module DatesHelper
  def humanize_date(date)
    I18n.l(date, format: :long)
  end

  def format_utc_datetime(datetime)
    datetime.strftime('%d.%m.%Y %H:%M:%S')
  end

  def days_passed_in_year
    (Date.current - Date.current.beginning_of_year).to_i + 1
  end

  def formatted_month_days(months_data, month)
    months_data[month.to_s.rjust(2, '0')] || {}
  end
end