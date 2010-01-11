Factory.define :boss do |f|
  f.name 'Boss'
end

Factory.define :zone do |f|
  f.name 'Zone'
end

Factory.define :loot_table_zone, :class => LootTable do |f|
  f.association :object, :factory => :zone
  f.parent_id nil
end

Factory.define :loot_table_boss, :class => LootTable do |f|
  f.association :object, :factory => :boss
  f.association :parent, :factory => :loot_table_zone
end

Factory.define :loot_table do |f|
  f.association :object, :factory => :item
  f.association :parent, :factory => :loot_table_boss
end