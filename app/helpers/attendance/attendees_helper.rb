module Attendance::AttendeesHelper
  def link_to_toggle_attendee(live_attendee)
    if live_attendee.active?
      image = image_tag('tick.png')
    else
      image = image_tag('cancel.png')
    end
    
    if live_attendee.live_raid.active?
      link_to_remote(image, :method => :put,
        :url => live_raid_live_attendee_path(live_attendee.live_raid, live_attendee))
    else
      image
    end
  end
end
