module CategoriesHelper
  def render_categories(categories, unfinished_period)
    content_tag(:div, class: "categories-list") do
      categories.each do |category|
        concat(render(partial: 'categories/category_card', locals: { category: category, unfinished_period: unfinished_period }))
      end
    end
  end

  def active_period_by_category(category)
    last_period = category.periods.order(start: :desc).first
    last_period&.end ? nil : last_period
  end

  def indicator_properties(value)
    if value > 0
      { color: 'green', text: 'Increased by', icon_filename: 'icons/increased.svg' }
    elsif value < 0
      { color: 'red', text: 'Decreased by', icon_filename: 'icons/decreased.svg' }
    else
      { color: 'gray', text: 'No change', icon_filename: nil }
    end
  end
end
