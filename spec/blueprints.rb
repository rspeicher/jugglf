require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.define do
  name { Faker::Name.first_name }
  price(:unique => false) { 1.0 }
end

Achievement.blueprint do
  title { Faker::Lorem.words(5) }
  icon { 'icon' }
  armory_id { Faker::Address.zip_code }
end
CompletedAchievement.blueprint do
  member
  achievement
  completed_on { Date.today }
end

MemberRank.blueprint do
  name
  prefix { '<b>' }
  suffix { '</b>' }
end

Member.blueprint do
  name
  wow_class { nil }
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
  name { Faker::Lorem.words(2) }
  wow_id { 12345 }
  color { 'q4' }
  icon { 'INV_Icon_01' }
  level { 223 }
  slot { 'Trinket' }
end
# Item.blueprint(:with_stats) do
# end
Item.blueprint(:with_real_stats) do
  name { 'Torch of Holy Fire' }
  wow_id { 40395 }
  icon { 'INV_Mace_82' }
  level { 226 }
  slot { 'Main Hand' }
end
Loot.blueprint do
  item
  member
  raid
  price
  purchased_on { Date.today }
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

# -----------------------------------------------------------------------------

Wishlist.blueprint do
  member
  item
  priority { 'normal' }
  note { 'I really want this item!' }
end

Zone.blueprint do
  name
end

Boss.blueprint do
  name
end

LootTable.blueprint do
end

# -----------------------------------------------------------------------------

InvisionUser.blueprint do
  name
  mgroup { 1 }
  email { Faker::Internet.email }
  converge { InvisionUserConverge.make }
  member { nil }
end
InvisionUser.blueprint(:admin) do
  mgroup { 4 }
end

InvisionUserConverge.blueprint do
  converge_pass_hash { '9c4acc137217b795b4d487bba53f5e7d' } # pass!word salted with 'salt'
  converge_pass_salt { 'salt' }
end