Factory.define :item do |f|
  f.sequence(:name) { |n| "Item#{n}" }
  f.sequence(:wow_id) { |n| n }
  f.authentic true
end

Factory.define :item_with_real_stats, :class => Item do |f|
  f.name 'Torch of Holy Fire'
  f.wow_id 40395
  f.icon 'INV_Mace_82'
  f.color 'q4'
  f.level 226
  f.slot 'Main Hand'
  f.authentic true
end

Factory.define :item_needing_lookup, :default_strategy => :build, :class => Item do |f|
  f.wow_id 1
  f.authentic false
end