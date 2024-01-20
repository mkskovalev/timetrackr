module ProfilesHelper
  def time_zone_options_for_select(selected = nil)
    ActiveSupport::TimeZone.all.map do |zone|
      utc_offset = zone.utc_offset / 3600
      formatted_offset = "UTC #{utc_offset > 0 ? '+' : ''}#{utc_offset}:00"
      selected_attribute = zone.name == selected ? ' selected' : ''
      "<option value=\"#{zone.name}\"#{selected_attribute}>(#{formatted_offset}) #{zone.name}</option>"
    end.join.html_safe
  end
end
