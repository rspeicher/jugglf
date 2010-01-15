Factory.define :loot do |f|
  f.association :item
  f.price 0.0
  f.purchased_on Date.today
end

Factory.define :loot_with_buyer, :parent => :loot do |f|
  f.association :member
end