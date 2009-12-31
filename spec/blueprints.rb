require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.define do
  name { Faker::Name.first_name }
  price(:unique => false) { 1.0 }
  wow_id { Faker::Address.zip_code }
  item_name { Faker::Lorem.words(2) }
end

Achievement.blueprint do
  title { Faker::Lorem.words(5) }
  icon { 'icon' }
  armory_id { Sham.wow_id }
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
  name { Sham.item_name }
  wow_id
  color { 'q4' }
  icon { 'INV_Icon_01' }
  level { 223 }
  slot { 'Trinket' }
  authentic { true } # Not really, but it for the purposes of specs it's fine?
end
Item.blueprint(:with_real_stats) do
  name { 'Torch of Holy Fire' }
  wow_id { 40395 }
  icon { 'INV_Mace_82' }
  level { 226 }
  slot { 'Main Hand' }
  authentic { true }
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

User.blueprint do
  name
  member_group_id { 1 }
  email { Faker::Internet.email }
  member { nil }
  persistence_token { 'b18f1a5dc276001e6fe20139d5522755e414cdee' }
end
User.blueprint(:admin) do
  member_group_id { 4 }
end

# -----------------------------------------------------------------------------

LiveLoot.blueprint do
  item
  loot_type { nil }
end