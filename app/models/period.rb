class Period < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :category, dependent: :destroy

  validates :start, presence: true

  def formatted_time
    total_seconds = (self.end - self.start).to_i
    hours = total_seconds / 3600
    minutes = (total_seconds / 60) % 60
    seconds = total_seconds % 60

    format("%02d:%02d:%02d", hours, minutes, seconds)
  end
end
