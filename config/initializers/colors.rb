BASE_COLORS = [
  'Red', 
  'Orange', 
  'Yellow', 
  'Lime', 
  'Green', 
  'Cyan', 
  'Blue', 
  'Purple', 
  'Fuchsia', 
  'Pink', 
].freeze

SHADES = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950].freeze

BG_COLORS = {
  'White' => ['bg-white'],
  'Black' => ['bg-black']
}.merge(
  BASE_COLORS.map { |color| [color, SHADES.map { |shade| "bg-#{color.downcase}-#{shade}" }] }.to_h
).freeze

TEXT_COLORS = BASE_COLORS.each_with_object({}) do |color, hash|
  SHADES.each do |shade|
    bg_class = "bg-#{color.downcase}-#{shade}"
    text_class = shade <= 500 ? "#{color.downcase}-900" : "#{color.downcase}-100"
    hash[bg_class] = "text-#{text_class}"
  end
end
TEXT_COLORS['bg-white'] = 'text-gray-950'
TEXT_COLORS['bg-black'] = 'text-gray-50'