class Goal < ApplicationRecord
  belongs_to :user
  belongs_to :category

  SCHEDULES = %w(daily weekly monthly)

  validates :duration, presence: true, numericality: { greater_than: 0 }
  validates :schedule, presence: true, inclusion: { in: SCHEDULES }
end
