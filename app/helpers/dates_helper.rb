module DatesHelper
  def humanize_date(date)
    I18n.l(date, format: :long)
  end

  def format_utc_datetime(datetime)
    datetime.strftime('%d.%m.%Y %H:%M:%S')
  end
end