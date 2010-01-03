Factory.define :live_raid do |raid|
end

Factory.define :live_raid_with_attendee, :parent => :live_raid do |raid|
  raid.after_create { |r| Factory(:live_attendee, :live_raid => r) }
end