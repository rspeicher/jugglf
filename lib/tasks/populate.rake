namespace :db do
  desc "Erase and fill database"
  task :populate => [:environment] do
    require 'populator'
    require 'faker'
    
    [Member].each(&:delete_all)
    
    Member.populate 100 do |m|
      m.name                = Faker::Name.first_name
      m.active              = 1
      m.first_raid          = 2.years.ago..Time.now
      m.last_raid           = m.first_raid..Time.now
      m.raid_count          = 0
      m.wow_class           = ['Death Knight','Druid','Hunter','Mage','Paladin','Priest','Rogue','Shaman','Warlock','Warrior']
      m.lf                  = 0..100
      m.sitlf               = 0..100
      m.bislf               = 0..100
      m.attendance_30       = 0..100
      m.attendance_90       = 0..100
      m.attendance_lifetime = 0..100
    end
    
    Member.find(:all).each do |m|
      m.lf                  = m.lf * 1.00
      m.sitlf               = m.sitlf * 1.00
      m.bislf               = m.bislf * 1.00
      m.attendance_30       = m.attendance_30 / 100
      m.attendance_90       = m.attendance_90 / 100
      m.attendance_lifetime = m.attendance_lifetime / 100
      m.save!
    end
  end
end