Factory.define :live_attendee do |la|
  la.member_name 'Tsigo'
  la.association :live_raid
  la.active true
end