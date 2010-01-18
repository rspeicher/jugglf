Factory.define :wishlist do |f|
  f.association :item
  f.association :member
  f.priority 'normal'
end

Factory.define :empty_wishlist, :class => Wishlist, :default_strategy => :build do |f|
  f.priority 'normal'
end