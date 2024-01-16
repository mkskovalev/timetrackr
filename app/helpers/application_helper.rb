module ApplicationHelper
  def menu_item(name, path)
    active_class = current_page?(path) ? 'bg-gray-900 text-white' : 'text-gray-300 hover:bg-gray-700 hover:text-white'

    content_tag :a, href: path, class: "#{active_class} group flex items-center px-2 py-2 text-sm font-medium rounded-md" do
    yield if block_given?
    concat(name)
    end
  end
end
