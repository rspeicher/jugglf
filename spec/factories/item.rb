Factory.define :item do |f|
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