Factory.define :user, :default_strategy => :build do |f|
  f.sequence(:name) { |n| "User#{n}" }
  f.sequence(:email) { |n| "user#{n}@email.com" }
  f.member_group_id 1
  f.persistence_token 'b18f1a5dc276001e6fe20139d5522755e414cdee'
  f.members_pass_salt 'abcde'
  f.members_pass_hash 'f838bbffaae3e444cdf5a27a6a12a347' # "password" salted with "abcde"
end

Factory.define :admin, :parent => :user, :default_strategy => :build do |f|
  f.member_group_id 4
end
