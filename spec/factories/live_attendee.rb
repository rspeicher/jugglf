Factory.define :live_attendee do |la|
  la.sequence(:member_name) { |n| "Attendee#{n}" }
end

Factory.define :live_attendee_with_raid, :parent => :live_attendee do |la|
  la.association :live_raid
  la.active true
end