every 1.day, :at => '10:30 am' do
  rake 'juggernaut:cleanup'
  rake 'juggernaut:lootfactors'
end

every 1.day, :at => '11:00 am' do
  rake 'juggernaut:achievements'
end

every 20.minutes do
  runner 'Session.delete_all [\'updated_at < ?\', 20.minutes.ago]'
end