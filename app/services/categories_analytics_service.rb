module CategoriesAnalyticsService
  def self.calculate_time_difference(category)
    return nil unless category

    last_30_days = total_time_in_range(category, 30.days.ago, Time.current)
    previous_30_days = total_time_in_range(category, 60.days.ago, 30.days.ago)

    return 0 if previous_30_days.zero?

    percentage_difference(last_30_days, previous_30_days)
  end

  def self.seconds_to_time_format(total_seconds)
    hours = ((total_seconds / (60 * 60)) % 24).round(0)
    minutes = ((total_seconds / 60) % 60).round(0)
    seconds = (total_seconds % 60).round(0)

    hours > 0 ? "#{pad_with_leading_zero(hours)}h 
                 #{pad_with_leading_zero(minutes)}m 
                 #{pad_with_leading_zero(seconds)}s" : "
                 #{pad_with_leading_zero(minutes)}m 
                 #{pad_with_leading_zero(seconds)}s"
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
    total_time = 0
    categories = [category] + category.descendants

    categories.each do |cat|
      cat.periods.each do |period|
        adjusted_start = [period.start, start_date].max
        adjusted_end = [period.end || end_date, end_date].min
        total_time += adjusted_end - adjusted_start if adjusted_end > adjusted_start
      end
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

  def self.pad_with_leading_zero(number)
    number >= 10 ? number.to_s : "0#{number}"
  end
end
