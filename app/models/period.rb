class Period < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :start, presence: true

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
end
