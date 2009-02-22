require 'faker'

# Sham attribute definitions
Sham.define do
  name { Faker::Name.first_name }
  price { 1.00 }
end

Member.blueprint do
  name
end

Raid.blueprint do
  date { Date.today }
end

Item.blueprint do
  name
  member
  raid
end

Attendee.blueprint do
  raid
  member
  attendance { 0.85 }
end