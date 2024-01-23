module ChartDataService
  def self.aggregate_periods_by_days(category, number_of_days = 7)
    start_date = (number_of_days - 1).days.ago.to_date
    end_date = Date.tomorrow

    all_periods = collect_all_periods(category, start_date, end_date)

    periods_by_day = all_periods.group_by { |period| period.start_in_zone.strftime("%d.%m") }
                                .transform_values do |periods|
                                  periods.sum { |period| period.end ? (period.end - period.start).to_i : 0 }
                                end

    sorted_periods_by_day = (start_date..end_date).each_with_object({}) do |date, hash|
      hash[date.strftime("%d.%m")] = periods_by_day[date.strftime("%d.%m")] || 0 if date != Date.tomorrow
    end

    sorted_periods_by_day
  end

  private

  def self.collect_all_periods(category, start_date, end_date)
    periods = []
    categories = [category] + category.descendants

    categories.each do |cat|
      cat.periods.each do |period|
        adjusted_start = [period.start, start_date].max
        adjusted_end = [period.end || end_date, end_date].min
        periods << Period.new(start: adjusted_start, end: adjusted_end) if adjusted_end > adjusted_start
      end
    end

    periods
  end
end
