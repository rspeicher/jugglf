# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
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
end
