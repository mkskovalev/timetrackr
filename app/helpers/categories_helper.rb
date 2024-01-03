module CategoriesHelper
  def render_categories(categories)
    content_tag(:div, class: "categories-list") do
      categories.each do |category|
        concat(render(partial: 'categories/category_card', locals: { category: category }))
      end
    end
  end
end
