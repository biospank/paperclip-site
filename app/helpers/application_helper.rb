module ApplicationHelper
  def nav_menu_item link_path, additional_class = nil, &block

    if link_path.is_a? String
      if link_path != main_app.root_path
        if request.path.start_with? link_path
          class_name = [additional_class, 'active'].join(' ')
        else
          class_name = [additional_class, ''].join(' ')
        end
      else
        class_name = [additional_class, (current_page?(link_path) ? 'active' : '')].join(' ')
      end
    else
      class_name = [additional_class, ((link_path.any? {|link| current_page?(link)}) ? 'active' : '')].join(' ')
    end

    content_tag(:li, '', :class => class_name) do
      block.call if block_given?
    end
  end
end
