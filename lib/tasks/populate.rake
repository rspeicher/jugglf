namespace :db do
  desc "Erase and fill database"
  task :populate => [:environment] do
    require 'populator'
    require 'faker'
    
    wow_classes = ['Death Knight','Druid','Hunter','Mage','Paladin','Priest',
      'Rogue','Shaman','Warlock','Warrior']
    
    [Attendee, Member, Raid].each(&:delete_all)
    
    # Members ------------------------------------------------------------------
    Member.populate 100 do |m|
      m.name                = Faker::Name.first_name
      m.active              = 1
      m.first_raid          = 2.years.ago..Time.now
      m.last_raid           = m.first_raid..Time.now
      m.raid_count          = 0
      m.wow_class           = wow_classes
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
    
    # Raids --------------------------------------------------------------------
    Raid.populate 15..250 do |r|
      r.date   = 2.years.ago..Time.now
      r.note   = Populator.words(0..8).titleize
      r.thread = 0
    end
    
    # Attendees ----------------------------------------------------------------
    Raid.find(:all).each do |r|
      begin
        rand(40).times do
          a = Attendee.new
          a.raid       = r
          a.member     = Member.find(:first, :order => 'RAND()')
          a.attendance = rand
          a.save!
        end
      rescue ActiveRecord::StatementInvalid => e
        # Might get an exception if we randomly got a member that already attended this raid
        # Just ignore it
      end
    end
  end
end