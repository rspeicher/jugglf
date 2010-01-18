Factory.sequence :item_id do |n|
  n
end

Factory.define :item do |f|
  f.after_build { |i| i.id = Factory.next :item_id }
  f.sequence(:name) { |n| "Item#{n}" }
  f.authentic true
end

Factory.define :item_with_real_stats, :class => Item do |f|
  f.after_build { |i| i.id = 40395 }
  f.name 'Torch of Holy Fire'
  f.icon 'INV_Mace_82'
  f.color 'q4'
  f.level 226
  f.slot 'Main Hand'
  f.authentic true
end

Factory.define :item_needing_lookup, :default_strategy => :build, :class => Item do |f|
  f.after_build { |i| i.id = nil }
  f.authentic false
end

Factory.define :item_needing_lookup_via_id, :default_strategy => :build, :class => Item do |f|
  f.after_build { |i| i.id = 1 }
  f.authentic false
end