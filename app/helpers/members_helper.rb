module MembersHelper
  # FIXME: This is ugly and potentially resource intensive
  def member_attendance(raid, member)
    if raid.members.include? member
      return raid_attendance_colored(raid.attendees.find_by_member_id(@member).attendance)
    else
      return raid_attendance_colored(0)
    end
  end
end
