Factory.define :member do |f|
  f.sequence(:name) { |n| "Member#{n}" }
  f.wow_class 'Druid'
end

Factory.define :member_hunter, :parent => :member do |f|
  f.wow_class 'Hunter'
end

Factory.define :declined_applicant, :parent => :member do |f|
  f.association :rank, :factory => :declined_applicant_rank
end