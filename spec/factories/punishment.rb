Factory.define :punishment do |f|
  f.reason 'Because I said so'
  f.expires Date.tomorrow
  f.value 0.0
end

Factory.define :punishment_expired, :parent => :punishment do |f|
  f.expires Date.yesterday
end