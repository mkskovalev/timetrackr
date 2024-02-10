class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_many :categories, dependent: :destroy
  has_many :periods, dependent: :destroy

  validates :locale, presence: true, 
                     inclusion: { in: I18n.available_locales.map(&:to_s) }

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

  def average_hourly_activity
    total_hours = Array.new(24, 0)
    date_range = self.periods.pluck(:start, :end).flatten.minmax
    return total_hours if date_range.any?(&:nil?)

    self.periods.find_each do |period|
      start_hour = period.start.hour
      end_hour = period.end.nil? ? Time.current.hour : period.end.hour
      end_hour += 24 if end_hour <= start_hour

      (start_hour...end_hour).each do |hour|
        adjusted_hour = hour % 24
        total_hours[adjusted_hour] += 1
      end
    end
  
    total_days = (date_range[1].to_date - date_range[0].to_date).to_i + 1
    average_hours = total_hours.map.with_index do |hour, index|
      start_hour = index
      end_hour = (index + 1) % 24
      period = "#{start_hour === 0 ? ''}-#{end_hour}"
      average_activity = (hour.to_f / total_days * 100).round(0)
      [period, average_activity]
    end.to_h

    average_hours
  end
  
end
