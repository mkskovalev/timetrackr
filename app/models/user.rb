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

  def activity_for_month(month)
    start_date = month.beginning_of_month
    end_date = month.end_of_month

    data = periods.where('start >= ? AND start <= ?', start_date, end_date)
                  .group_by_day(:start)
                  .sum('EXTRACT(EPOCH FROM (COALESCE("end", NOW()) - start))')

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
