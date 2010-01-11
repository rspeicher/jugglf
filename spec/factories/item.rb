Factory.sequence :item_name do |n|
  "Item#{n}"
end

Factory.sequence :item_wow_id do |n|
  n
end

Factory.define :item do |f|
  f.name { Factory.next :item_name }
  f.wow_id { Factory.next :item_wow_id }
  f.authentic true
end