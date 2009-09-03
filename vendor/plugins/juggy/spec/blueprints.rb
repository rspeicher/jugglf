require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.define do
end

Item.blueprint do
  name { Faker::Lorem.words(2) }
  wow_id { Faker::Address.zip_code }
  slot { 'Head' }
  level { 239 }
end
Item.blueprint(:with_real_stats) do
  name { 'Torch of Holy Fire' }
  wow_id { 40395 }
  icon { 'INV_Mace_82' }
  level { 226 }
  slot { 'Main Hand' }
end