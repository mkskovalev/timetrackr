class Period < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :start, presence: true
  validate :no_overlap, on: [:create, :update]

  def formatted_time(total_seconds = nil)
    return unless self.end
    total_seconds = total_seconds || (self.end - self.start).to_i
    CategoriesAnalyticsService.seconds_to_time_format(total_seconds)
  end

  def actual_end
    self.end || Time.now
  end

  def start_in_zone
    self.start&.in_time_zone
  end

  def end_in_zone
    self.end&.in_time_zone
  end

  def duration
    actual_end - start
  end

  def total_seconds_for_date(date)
    total_seconds = 0

    day_start = date.beginning_of_day
    day_end = date.end_of_day
    
    period_start = [self.start, day_start].max
    period_end = [actual_end, day_end].min
    
    total_seconds += [period_end - period_start, 0].max if period_start < period_end

    total_seconds
  end

  def self.expand_periods(periods)
    expanded_periods = []
  
    periods.each do |period|
      (period.start.to_date..period.actual_end.to_date).each do |date|
        expanded_periods << { date: date, period: period }
      end
    end
  
    expanded_periods
  end

  def self.group_periods_by_date(periods)
    grouped_periods = expand_periods(periods).group_by { |p| p[:date] }
    grouped_periods.transform_values { |periods| periods.map { |p| p[:period] } }
  end

  def formatted_time_for_date(date)
    if self.start.to_date != date && actual_end.to_date != date
      seconds = 60 * 60 * 24 # full day
    elsif self.start.to_date != date
      seconds = (self.end - date.beginning_of_day).to_i
    elsif actual_end.to_date != date
      seconds = (date.end_of_day - self.start).to_i
    end

    formatted_time(seconds)
  end

  def calculate_seconds_for_date(date)
    day_start = date.beginning_of_day
    day_end = date.end_of_day
  
    return 0 if self.start > day_end || (self.end && self.end < day_start)
  
    period_start = [self.start, day_start].max
    period_end = [(self.end || Time.current), day_end].min
  
    (period_end - period_start).to_i
  end

  private

  def no_overlap
    return if user.nil?
    
    period_end = self.end || Time.zone.now

    overlapping_periods = user.periods.where.not(id: id)
    overlapping_periods = overlapping_periods.where('start < ? AND ("end" > ? OR "end" IS NULL)', period_end, self.start)

    if overlapping_periods.exists?
      errors.add(:base, 'The period overlaps with an existing period')
    end
  end
end
