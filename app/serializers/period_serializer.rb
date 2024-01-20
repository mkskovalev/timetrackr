class PeriodSerializer
  def initialize(period)
    @period = period
  end

  def as_json(_ = nil)
    end_time = @period.end || Time.zone.now
    {
      id: @period.id,
      category_id: @period.category_id,
      start: @period.start,
      end: end_time,
      start_percentage: calculate_percentage_of_day(@period.start),
      width_percentage: calculate_percentage_of_day(end_time) - calculate_percentage_of_day(@period.start)
    }
  end

  private

  def calculate_percentage_of_day(time)
    (time.seconds_since_midnight / 86_400.0) * 100
  end
end
