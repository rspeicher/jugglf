require 'faker'

Sham.define do
end

Item.blueprint do
  name { Faker::Lorem.words(2) }
  wow_id { Faker::Address.zip_code }
  slot { 'Head' }
  level { 239 }
end