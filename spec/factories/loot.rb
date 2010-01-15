Factory.define :loot do |f|
  f.association :item
  f.price 0.0
end

Factory.define :loot_with_buyer, :parent => :loot do |f|
  f.association :member
  f.association :raid
end