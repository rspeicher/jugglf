Factory.sequence :member_name do |n|
  "Member#{n}"
end

Factory.define :member do |f|
  f.name { Factory.next :member_name }
  f.wow_class 'Druid'
end

Factory.define :member_hunter, :parent => :member do |f|
  f.wow_class 'Hunter'
end