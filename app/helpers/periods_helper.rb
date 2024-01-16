module PeriodsHelper
  def format_utc_datetime(datetime)
    datetime.getutc.strftime('%Y-%m-%d %H:%M:%S')
  end
end