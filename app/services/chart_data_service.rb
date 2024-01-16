module ChartDataService
  def self.aggregate_periods_by_days(category, number_of_days = 7)
    start_date = (number_of_days - 1).days.ago.to_date
    end_date = Date.tomorrow

    periods_in_range = category.periods.where(start: start_date..end_date)

    periods_by_day = periods_in_range.group_by { |period| period.start.strftime("%d.%m") }
                                     .transform_values do |periods|
                                       periods.sum { |period| period.end ? (period.end - period.start).to_i : 0 }
                                     end

    # Инициализируем хеш с нулевыми значениями для каждого дня в заданном диапазоне
    sorted_periods_by_day = (start_date..end_date).each_with_object({}) do |date, hash|
      hash[date.strftime("%d.%m")] = periods_by_day[date.strftime("%d.%m")] || 0 if date != Date.tomorrow
    end

    sorted_periods_by_day
  end
end
