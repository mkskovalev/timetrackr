class PeriodSerializer
  def initialize(period)
    @period = period
  end

  def as_json(_ = nil)
    end_time = @period.end || Time.zone.now
    start_time = @period.start < Time.zone.now.beginning_of_day ? Time.zone.now.beginning_of_day : @period.start
    start_percentage = start_time == Time.zone.now.beginning_of_day ? 0 : calculate_percentage_of_day(start_time)

    {
      id: @period.id,
      category_id: @period.category_id,
      start: @period.start,
      end: end_time,
      start_percentage: start_percentage,
      width_percentage: calculate_percentage_of_day(end_time) - start_percentage
    }
  end

  private

  def calculate_percentage_of_day(time)
    (time.seconds_since_midnight / 86_400.0) * 100
  end
end
