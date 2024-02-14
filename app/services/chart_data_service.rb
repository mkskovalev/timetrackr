module ChartDataService
  def self.categories_data_for_chart(user, time_period, category_level)
    categories = if category_level == 'top_level'
                   user.categories.where(parent_id: nil)
                 else
                  user.categories.select { |category| category.children.empty? }
                 end

    start_date, end_date = calculate_time_period_range(user, time_period)

    data = categories.map do |category|
      total_seconds = CategoriesAnalyticsService.total_time_in_range(category, start_date, end_date)
      { name: category.name, total_seconds: total_seconds, color: category.color }
    end

    data.to_json
  end

  def self.average_hourly_activity(user, time_period)
    total_hours = Array.new(24, 0)
    start_date, end_date = calculate_time_period_range(user, time_period)
    periods = user.periods.where(start: start_date.beginning_of_day..end_date.end_of_day)
    
    return total_hours if periods.empty?
    
    periods.find_each do |period|
      start_hour = period.start.hour
      end_hour = period.end.nil? ? end_date.hour : period.end.hour
      end_hour += 24 if end_hour < start_hour

      if start_hour == end_hour
        total_hours[start_hour] += 1
      else
        (start_hour...end_hour).each do |hour|
          adjusted_hour = hour % 24
          total_hours[adjusted_hour] += 1
        end
      end
    end
  
    total_days = (end_date.to_date - start_date.to_date).to_i + 1
    average_hours = total_hours.map.with_index do |periods_in_hour, index|
      start_hour = CategoriesAnalyticsService.pad_with_leading_zero(index)
      end_hour = CategoriesAnalyticsService.pad_with_leading_zero((index + 1) % 24)
      period = "#{start_hour}:00-#{end_hour}:00"
      [period, periods_in_hour.round(0)]
    end.to_h
  
    average_hours
  end

  def self.completion_percentage(goal)
    schedule = goal.schedule
    start_date, end_date = period_for_schedule(schedule)

    total_seconds = CategoriesAnalyticsService.total_time_in_range(goal.category, start_date, end_date)
    total_minutes = total_seconds.to_f / 60

    percentage = ((total_minutes / goal.duration) * 100).round(0)
    percentage > 100 ? 100 : percentage
  end

  private

  def self.period_for_schedule(schedule)
    case schedule
    when 'daily'
      start_date = Time.zone.now.beginning_of_day
      end_date = Time.zone.now.end_of_day
    when 'weekly'
      start_date = Time.zone.now.beginning_of_week
      end_date = Time.zone.now.end_of_week
    when 'monthly'
      start_date = Time.zone.now.beginning_of_month
      end_date = Time.zone.now.end_of_month
    else
      raise ArgumentError, "Unknown schedule: #{schedule}"
    end

    [start_date, end_date]
  end

  def self.collect_all_periods(category, start_date, end_date)
    periods = []
    categories = [category] + category.descendants

    categories.each do |cat|
      cat.periods.each do |period|
        adjusted_start = [period.start, start_date].max
        adjusted_end = [period.end || end_date, end_date].min
        periods << Period.new(start: adjusted_start, end: adjusted_end) if adjusted_end > adjusted_start
      end
    end

    periods
  end

  def self.calculate_time_period_range(user, time_period)
    end_date = Time.current.end_of_day
    start_date = case time_period
                 when 'last_30_days'
                   30.days.ago.beginning_of_day
                 when 'last_7_days'
                   7.days.ago.beginning_of_day
                 else
                   user.periods.minimum(:start)
                 end
    [start_date, end_date]
  end
end
