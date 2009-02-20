module MembersHelper
  def member_with_rank_formatting(member)
    return member.name if member.rank.nil?
    
    member.rank.format(member.name)
  end
  
  def link_to_member(member)
    link_to h(member.name), member_path(member), :class => member.wow_class unless member.nil?
  end
  
  # FIXME: This is ugly and potentially resource intensive
  def member_raid_attendance(raid, member)
    if raid.members.include? member
      return raid_attendance_colored(raid.attendees.find_by_member_id(@member).attendance)
    else
      return raid_attendance_colored(0)
    end
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
end
