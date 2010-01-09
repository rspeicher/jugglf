Factory.define :user, :default_strategy => :build do |f|
  f.name 'User'
  f.member_group_id 1
  f.persistence_token 'b18f1a5dc276001e6fe20139d5522755e414cdee'
end

Factory.define :admin, :parent => :user, :default_strategy => :build do |f|
  f.member_group_id 4
end