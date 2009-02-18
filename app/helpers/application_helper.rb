# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def link_to_tab(text, path = nil)
    path = ( path.nil? ) ? "##{text.gsub(/^(\w+).*/, '\1').downcase}" : path
    
    link_to "<span>#{text}</span>", path
  end
  
  def member_link_colored(member)
    link_to h(member.name), member_path(member), :class => member.wow_class unless member.nil?
  end
  
  def member_attendance_colored(value)
    if value.class == Float
      value = (value * 100).floor
    end
    
    if value >= 0 and value <= 34
      class_str = 'negative'
    elsif value >= 35 and value <= 66
      class_str = 'neutral'
    elsif value >= 67 and value <= 100
      class_str = 'positive'
    else
      class_str = 'neutral'
    end
    
    "<span class=\"#{class_str}\">#{value}%</span>"
  end
  def raid_attendance_colored(value)
    if value.class == Float
      value = (value * 100).floor
    end
    
    if value == 100
      class_str = 'positive'
    elsif value == 0
      class_str = 'negative'
    else
      class_str = 'neutral'
    end

    "<span class=\"#{class_str}\">#{value}%</span>"
  end
  
  def progress_bar(width, *args)
    options = args.extract_options!
    options.symbolize_keys!
    
    defaults = { 
      :container_width => "95",
      :color => "#ACE97C"
    }
    container_width ||= (options[:container_width] || defaults[:container_width])
    color ||= (options[:color] || defaults[:color])
    
    "<div class='progress-container' style='width: #{container_width.to_i}%'>" +
      "<div style='width: #{width.to_i}%; background-color: #{color}'></div>" +
    "</div>"
  end
end