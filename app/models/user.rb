class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_many :categories, dependent: :destroy
  has_many :periods, dependent: :destroy

  def categories_for_timeline
    filtered_periods = periods.where("periods.end >= ? OR periods.end IS NULL", Time.zone.now.utc.beginning_of_day)

    categories.joins(:periods)
              .where(periods: { id: filtered_periods.select(:id) })
              .distinct 
  end
end
