Factory.define :completed_achievement do |f|
  f.association :member
  f.association :achievement
  f.completed_on Date.today
end