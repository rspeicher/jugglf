Factory.define :punishment do |f|
  f.reason 'Reason'
  f.expires_on 1.year.since(Date.today)
  f.value 0.0
end

Factory.define :expired_punishment, :parent => :punishment do |f|
  f.expires_on Date.yesterday
end