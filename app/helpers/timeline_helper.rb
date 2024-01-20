module TimelineHelper
  def formatted_hours(step)
    (0..24).step(step).map do |hour|
      hour < 10 ? "0#{hour}:00" : "#{hour}:00"
    end
  end
end
