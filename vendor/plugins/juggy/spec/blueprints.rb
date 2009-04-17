require 'faker'

Sham.define do
end

ItemStat.blueprint do
  wow_id { Faker::Address.zip_code }
  item { Faker::Lorem.words(2) }
  slot { 'Head' }
  level { 239 }
end