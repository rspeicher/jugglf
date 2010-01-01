Factory.define :live_raid do |lr|
end

Factory.define :live_raid_with_attendees, :parent => :live_raid do |lr|
  lr.live_attendees { |att| [att.association(:live_attendee), att.association(:live_attendee)] }
end