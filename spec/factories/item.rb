Factory.sequence :wow_id do |n|
  n
end

Factory.define :item do |f|
  f.name 'Item'
  f.wow_id Factory.next(:wow_id)
  f.authentic true
end