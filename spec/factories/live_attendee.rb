Factory.define :live_attendee do |att|
  att.sequence(:member_name) { |n| "Attendee#{n}" }
end

Factory.define :live_attendee_with_raid, :parent => :live_attendee do |att|
  att.association :live_raid
  att.started_at Time.now
  att.active true
end