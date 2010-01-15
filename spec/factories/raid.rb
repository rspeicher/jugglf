Factory.define :raid do |f|
  f.date Date.today
end

Factory.define :raid_with_attendee, :parent => :raid do |f|
  f.after_create { |r| Factory(:attendee, :raid => r) }
end