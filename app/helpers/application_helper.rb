module ApplicationHelper
  def menu_item(name, path, admin_panel = false)
    color_name = admin_panel ? 'purple' : 'gray'
    active_class = current_page?(path) ? "bg-#{ color_name }-900 text-white" : "text-#{ color_name }-300 hover:bg-#{ color_name }-700 hover:text-white"

    content_tag :a, href: path, class: "#{active_class} group flex items-center px-2 py-2 text-sm font-medium rounded-md" do
    yield if block_given?
    concat(name)
    end
  end

  def flash_color(type)
    case type
    when 'success'
      'bg-green-500'
    when 'notice'
      'bg-green-500'
    when 'danger'
      'bg-red-500'
    when 'alert'
      puts 'alert'
      'bg-red-500'
    when 'warning'
      'bg-yellow-500'
    when 'info'
      'bg-blue-500'
    end
  end
end
