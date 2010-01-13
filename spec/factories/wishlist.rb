Factory.define :wishlist do |f|
  f.association :item
  f.association :member
  f.priority 'normal'
end