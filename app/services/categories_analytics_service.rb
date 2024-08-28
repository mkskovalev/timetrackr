module CategoriesAnalyticsService
  def self.seconds_to_time_format(total_seconds, long = false)
    return I18n.t(:no_data) if total_seconds.blank? || total_seconds.zero?

    hours = total_seconds.div(3600)
    minutes = total_seconds.div(60) % 60
    seconds = (total_seconds % 60).round(0)
  
    if seconds == 60
      minutes += 1
      seconds = 0
    end
  
    if minutes == 60
      hours += 1
      minutes = 0
    end
  
    format_string = ''

    if long
      format_string += hours > 0 ? "#{ I18n.t('time.hours', count: hours) } " : ''
      format_string += minutes > 0 ? "#{ minutes } #{ I18n.t(:minutes) } " : ''
    else
      format_string += "#{pad_with_leading_zero(hours)}:" if hours > 0
      format_string += "#{pad_with_leading_zero(minutes)}:"
      format_string += "#{pad_with_leading_zero(seconds)}"
    end
  
    format_string.strip
  end

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

  def self.average_time_per_day_in_range(category, start_date, end_date)
    return 0 if start_date.blank?

    total_time = total_time_in_range(category, start_date, end_date)
    days_count = (end_date.to_date - start_date.to_date).to_i + 1
    average_time_per_day = total_time / days_count.to_f
    average_time_per_day
  end

  def self.pad_with_leading_zero(number)
    number >= 10 ? number.to_s : "0#{number}"
  end

  def self.percentage_difference(current_period, previous_period)
    current_period = current_period.to_f
    previous_period = previous_period.to_f
  
    return 0 if previous_period.zero?
  
    ((current_period - previous_period) / previous_period * 100).round(0)
  end
  
  private

  def self.valid_period?(period, start_date, end_date)
    period.end && period.end >= start_date && period.start <= end_date
  end

  def self.calculate_period_time(period, start_date, end_date)
    [(period.end || end_date) - period.start, 0].max
  end
end
