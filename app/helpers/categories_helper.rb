module CategoriesHelper
  def render_categories(categories, unfinished_period)
    content_tag(:div, class: "categories-list") do
      categories.each do |category|
        concat(render(partial: 'categories/category_card', locals: { category: category, unfinished_period: unfinished_period }))
      end
    end
  end

  def active_period_by_category(category)
    # Используем [-1] для доступа к последнему загруженному объекту,
    # чтобы избежать дополнительного запроса к базе данных.
    last_period = category.periods.to_a.last
    last_period&.end ? nil : last_period
  end
end
