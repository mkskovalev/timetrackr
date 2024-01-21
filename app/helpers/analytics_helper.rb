module AnalyticsHelper
  def activity_level(activity_data, day)
    level = activity_data[day] ? (activity_data[day] / activity_data[:max] * 1000).round(-2) : 0
    color_index = level.clamp(50, 600)
    color_index = (color_index / 100).round * 100
    color_index = 50 if color_index < 100
    color_index
  end
end
