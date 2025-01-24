module ReportsService
  def self.generate_weekly_report(user, start_date, end_date, prev_start_date, prev_end_date)
    report = {}

    report[:start_date] = start_date
    report[:end_date] = end_date
    report[:categories] = {}

    user.categories.joins(:periods).each do |category|
      total_time = CategoriesAnalyticsService.total_time_in_range(category, start_date, end_date)
      prev_total_time = CategoriesAnalyticsService.total_time_in_range(category, prev_start_date, prev_end_date)

      formatted_time = CategoriesAnalyticsService.seconds_to_time_format(total_time)
      percentage_change = CategoriesAnalyticsService.percentage_difference(total_time, prev_total_time)

      report[:categories][category.name] = {
        time_spent: formatted_time,
        percentage_change: percentage_change
      }
    end

    report
  end
end