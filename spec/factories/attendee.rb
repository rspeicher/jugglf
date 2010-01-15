Factory.define :attendee do |f|
  f.association :member
  f.association :raid
  f.attendance 1.0
end