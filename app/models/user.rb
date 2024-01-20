class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_many :categories, dependent: :destroy
  has_many :periods, dependent: :destroy

  def categories_for_timeline
    categories.includes(:periods)
      .where(
        periods: { 
          start: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
        }
      )
      .order("periods.start ASC")
  end
end
