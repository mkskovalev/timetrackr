module ColorHelper
  def adjust_color_intensity(type, bg_class, adjustment)
    parts = bg_class.split('-')

    if ['white', 'black'].include?(parts[1])
      color_name = 'gray'
      intensity = parts[1] == 'white' ? 100 : 900
    else
      color_name = parts[1]
      intensity = parts[2].to_i
    end

    new_intensity = if intensity >= 500
                      intensity > 900 ? 900 : [intensity - adjustment, 50].max
                    else
                      intensity < 100 ? [intensity + adjustment, 950].min.round(-2) : [intensity + adjustment, 950].min
                    end

    "#{type}-#{color_name}-#{new_intensity}"
  end
end
