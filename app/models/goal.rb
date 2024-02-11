class Goal < ApplicationRecord
  belongs_to :user
  belongs_to :category

  SCHEDULES = %w(daily weekly monthly)

  validates :duration, presence: true, numericality: { greater_than: 0 }
  validates :schedule, presence: true, inclusion: { in: SCHEDULES }
  validates :category_id, uniqueness: { scope: :user_id, message: "You can only have one goal per category" }

  def hours
    duration / 60 if duration
  end

  def minutes
    duration % 60 if duration
  end
end
