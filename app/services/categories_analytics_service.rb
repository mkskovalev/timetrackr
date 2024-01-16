module CategoriesAnalyticsService
  def self.calculate_time_difference(category)
    return nil unless category

    last_30_days = total_time_in_range(category, 30.days.ago, Time.current)
    previous_30_days = total_time_in_range(category, 60.days.ago, 30.days.ago)

    return 0 if previous_30_days.zero?

    percentage_difference(last_30_days, previous_30_days)
  end

  def self.seconds_to_time_format(total_seconds)
    hours = total_seconds / (60 * 60)
    minutes = (total_seconds / 60) % 60
    seconds = total_seconds % 60

    format("%02d:%02d:%02d", hours, minutes, seconds)
  end

  def self.total_time_last_30_days(category)
    total_seconds = total_time_in_range(category, 30.days.ago, Time.current)
    seconds_to_time_format(total_seconds)
  end

  def self.average_seconds_per_day_last_30_days(category)
    total_time_last_30_days = total_time_in_range(category, 30.days.ago, Time.current)
    (total_time_last_30_days / 30.0).round
  end

  def self.average_time_per_day_last_30_days(category)
    average_seconds = average_seconds_per_day_last_30_days(category)
    seconds_to_time_format(average_seconds)
  end

  def self.average_time_difference_last_60_days(category)
    avg_last_30_days = average_seconds_per_day_last_30_days(category)
    avg_previous_30_days = total_time_in_range(category, 60.days.ago, 30.days.ago) / 30.0

    percentage_difference(avg_last_30_days, avg_previous_30_days)
  end

  private

  def self.total_time_in_range(category, start_date, end_date)
    total_time = category.periods.select { |period| valid_period?(period, start_date, end_date) }
                                 .sum { |period| calculate_period_time(period, start_date, end_date) }

    category.childrens.each do |child|
      total_time += total_time_in_range(child, start_date, end_date)
    end

    total_time
  end

  def self.valid_period?(period, start_date, end_date)
    period.end && period.end >= start_date && period.start <= end_date
  end

  def self.calculate_period_time(period, start_date, end_date)
    [(period.end || end_date) - period.start, 0].max
  end

  def self.percentage_difference(current_period, previous_period)
    current_period = current_period.to_f
    previous_period = previous_period.to_f
  
    return 0 if previous_period.zero?
  
    ((current_period - previous_period) / previous_period * 100).round(0)
  end
end