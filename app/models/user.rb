class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_many :categories, dependent: :destroy
  has_many :periods, dependent: :destroy
  has_many :goals, dependent: :destroy
  has_many :reports, dependent: :destroy

  validates :locale, presence: true, 
                     inclusion: { in: I18n.available_locales.map(&:to_s) }
  validates :telegram_id, uniqueness: true, 
                          allow_nil: true
  
  after_create :send_admin_notification

  def categories_for_timeline
    filtered_periods = periods.where("periods.end >= ? OR periods.end IS NULL", Time.zone.now.beginning_of_day)

    categories.joins(:periods)
              .where(periods: { id: filtered_periods.select(:id) })
              .distinct 
  end

  def activity_for_month(month, category = nil)
    today = Date.today
    start_date = month.beginning_of_month
    end_date = [month.end_of_month, today].min

    data = {}
  
    (start_date..end_date).each do |date|
      beginning_of_day_local = Time.zone.local(date.year, date.month, date.day).beginning_of_day
      end_of_day_local = Time.zone.local(date.year, date.month, date.day).end_of_day
  
      current_time_utc = Time.now.utc
      end_of_period_utc = date == today ? [current_time_utc, end_of_day_local.utc].min : end_of_day_local.utc
  
      if category
        category_ids = category.ids_including_children
      else
        category_ids = self.categories.pluck(:id)
      end
  
      periods_for_day = self.periods.where(category_id: category_ids).where('start < ? AND ("end" IS NULL OR "end" > ?)', end_of_period_utc, beginning_of_day_local.utc)
  
      total_seconds = periods_for_day.reduce(0) do |sum, period|
        period_start = [period.start, date.beginning_of_day].max
        period_end = [period.end || Time.now, date.end_of_day].min
        sum + (period_end - period_start)
      end

      data[date] = total_seconds
    end
  
    data[:max] = data.values.max
    data
  end

  private

  def send_admin_notification
    AdminMailer.new_user_registered(self).deliver_now
  end
end
