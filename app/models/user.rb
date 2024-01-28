class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_many :categories, dependent: :destroy
  has_many :periods, dependent: :destroy

  def categories_for_timeline
    filtered_periods = periods.where("periods.end >= ? OR periods.end IS NULL", Time.zone.now.beginning_of_day)

    categories.joins(:periods)
              .where(periods: { id: filtered_periods.select(:id) })
              .distinct 
  end

  def activity_for_month(month)
    today = Date.today
    start_date = month.beginning_of_month
    end_date = [month.end_of_month, today].min

    data = {}
  
    (start_date..end_date).each do |date|
      beginning_of_day_local = Time.zone.local(date.year, date.month, date.day).beginning_of_day
      end_of_day_local = Time.zone.local(date.year, date.month, date.day).end_of_day
  
      current_time_utc = Time.now.utc
      end_of_period_utc = date == today ? [current_time_utc, end_of_day_local.utc].min : end_of_day_local.utc
  
      periods_for_day = periods.where('start < ? AND ("end" IS NULL OR "end" > ?)', end_of_period_utc, beginning_of_day_local.utc)
  
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
end
