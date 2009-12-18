require 'machinist/active_record'
require 'sham'
require 'faker'

module InvisionBridge
  InvisionUser.blueprint do
    name
    member_group_id { 1 }
    email { Faker::Internet.email }
    member { nil }
    persistence_token { 'b18f1a5dc276001e6fe20139d5522755e414cdee' }
  end
  InvisionUser.blueprint(:admin) do
    member_group_id { 4 }
  end
end