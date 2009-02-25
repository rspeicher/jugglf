require 'faker'

Sham.define do
  name { Faker::Name.first_name }
  price(:unique => false) { 1.0 }
end

MemberRank.blueprint do
  name
  prefix { '<b>' }
  suffix { '</b>' }
end

Member.blueprint do
  name
end
Member.blueprint(:hunter) do
  wow_class { 'Hunter' }
end

Raid.blueprint do
  date { Date.today }
end

Attendee.blueprint do
  raid
  member
  attendance { 0.85 }
end

Item.blueprint do
  name
  member
  raid
  price
end

Punishment.blueprint do
  member
  reason { Faker::Lorem.sentence(5) }
  expires { Date.tomorrow }
  value { Sham.price }
end
Punishment.blueprint(:expired) do
  expires { Date.yesterday }
end

ItemStat.blueprint do
  item_id { 12345 }
  item { Faker::Lorem.words(2) }
  color { 'q4' }
  icon { 'INV_Icon_01' }
  level { 223 }
  slot { 'Trinket' }
end
ItemStat.blueprint(:real) do
  item_id { 40395 }
  item { 'Torch of Holy Fire' }
  icon { 'INV_Mace_82' }
  level { 226 }
  slot { 'Main Hand' }
end

# -----------------------------------------------------------------------------

User.blueprint do
  self.login { Faker::Internet.user_name }
  password { 'password' }
  password_confirmation { 'password' }
  is_admin { false }
end
User.blueprint(:admin) do
  is_admin { true }
end

# -----------------------------------------------------------------------------

InvisionUser.blueprint do
  name
  mgroup { 4 }
  email { Faker::Internet.email }
  converge
end
InvisionUserConverge.blueprint do
  # converge_id { InvisionUser.make.id }
  converge_pass_hash { InvisionUser.generate_hash('admin', 'admin') }
  converge_pass_salt { 'admin' }
end