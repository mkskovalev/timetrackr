class Period < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :start, presence: true
  validate :no_overlap, on: [:create, :update]

  def formatted_time
    return unless self.end
    total_seconds = (self.end - self.start).to_i
    CategoriesAnalyticsService.seconds_to_time_format(total_seconds)
  end

  def start_in_zone
    self.start&.in_time_zone
  end

  def end_in_zone
    self.end&.in_time_zone
  end

  def duration
    (self.end || Time.current) - start
  end

  def calculate_today_seconds
    today = Time.now.utc.to_date
    end_time = self.end ? self.end : Time.now.utc
  
    return 0 if self.start.to_date != today && end_time.to_date != today
  
    period_start = [self.start, today.to_time].max
    period_end = [end_time, (today + 1).to_time].min
  
    (period_end - self.start).to_i
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
