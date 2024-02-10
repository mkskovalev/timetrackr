module PeriodsHelper
  def format_utc_datetime(datetime)
    datetime.strftime('%Y-%m-%d %H:%M:%S')
  end

  def total_seconds_for_date(date, periods)
    total_seconds = 0

    periods.each do |period|
      next if period.end.blank?
      day_start = date.beginning_of_day
      day_end = date.end_of_day
      
      period_start = [period.start, day_start].max
      period_end = [period.end, day_end].min
      
      total_seconds += [period_end - period_start, 0].max if period_start < period_end
    end

    total_seconds
  end

  def daily_period_ratio(date, period, periods)
    (period.calculate_seconds_for_date(date) / total_seconds_for_date(date, periods) * 100).round(2)
  end

  def format_period_end(period, date)
    period_ends_in_date = period.actual_end.to_date == date

    if period_ends_in_date
      period.end ? period.end.strftime('%H:%M') : '...'
    else
      '24:00'
    end
  end

  def format_period_start(period, date)
    period.start.to_date == date ? period.start.strftime('%H:%M') : '00:00'
  end

  def daily_periods_time(periods, date)
    total_seconds = periods.sum { |period| period.total_seconds_for_date(date) }
    CategoriesAnalyticsService.seconds_to_time_format(total_seconds)
  end
end