require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.define do
end

Item.blueprint do
  name { Faker::Lorem.words(2) }
  wow_id { Faker::Address.zip_code }
  slot { 'Head' }
  level { 277 }
end
Item.blueprint(:with_real_stats) do
  name { 'Torch of Holy Fire' }
  wow_id { 40395 }
  icon { 'INV_Mace_82' }
  level { 226 }
  slot { 'Main Hand' }
end
Item.blueprint(:old_onyxia_head) do
  name { 'Head of Onyxia' }
  wow_id { 18422 }
  icon { 'inv_misc_head_dragon_01' }
  level { 60 }
  slot { nil }
  color { 'q4' }
end
Item.blueprint(:new_onyxia_head) do
  name { 'Head of Onyxia' }
  wow_id { 49643 }
  icon { 'inv_misc_head_dragon_01' }
  level { 80 }
  slot { nil }
  color { 'q4' }
end