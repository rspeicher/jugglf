namespace :db do
  desc "Erase and fill database"
  task :populate => [:environment] do
    require 'populator'
    require 'faker'
    
    [Attendee, Item, Member, Raid].each(&:delete_all)
    
    kamien  = Member.create(:name => "Kamien",  :wow_class => "Rogue")  # 100% Lifetime
    sebudai = Member.create(:name => "Sebudai", :wow_class => "Hunter") # 100% 90-day
    tsigo   = Member.create(:name => "Tsigo",   :wow_class => "Priest") # 100% 30-day
    
    # Members ------------------------------------------------------------------
    begin
      Member.populate(50, :per_query => 1) do |m|
        m.name                = Faker::Name.first_name
        m.active              = 1
        # m.first_raid          = 2.years.ago..Time.now
        # m.last_raid           = m.first_raid..Time.now
        m.wow_class           = Member::WOW_CLASSES
        m.lf                  = 0..100
        m.sitlf               = 0..100
        m.bislf               = 0..100
        m.attendance_30       = 0..100
        m.attendance_90       = 0..100
        m.attendance_lifetime = 0..100
      end
      Member.all.each do |m|
        m.lf                  = m.lf * 1.00
        m.sitlf               = m.sitlf * 1.00
        m.bislf               = m.bislf * 1.00
        m.attendance_30       = m.attendance_30 / 100
        m.attendance_90       = m.attendance_90 / 100
        m.attendance_lifetime = m.attendance_lifetime / 100
        m.save!
      end
    rescue ActiveRecord::StatementInvalid => e
      # Probably a duplicate member name error
      # Just ignore it
    end
    
    # Raids --------------------------------------------------------------------
    Raid.populate(15..75, :per_query => 1) do |r|
      r.date   = 120.days.ago..Time.now
      r.note   = Populator.words(0..5).titleize
      r.thread = 0
    end
    
    # Attendees ----------------------------------------------------------------
    Raid.all.each do |r|
      Attendee.create(:raid_id => r.id, :member_id => kamien.id,  :attendance => 1.00)
      Attendee.create(:raid_id => r.id, :member_id => tsigo.id,   :attendance => 1.00) if r.date >= 30.days.ago.to_datetime
      Attendee.create(:raid_id => r.id, :member_id => sebudai.id, :attendance => 1.00) if r.date >= 90.days.ago.to_datetime

      begin
        rand(50).times do
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
    
    # Items --------------------------------------------------------------------
    Item.populate 300 do |i|
      i.name      = Populator.words(1).titleize
      i.price     = rand * 100
      i.member_id = Member.find(:first, :order => 'RAND()').id
      i.raid_id   = Raid.find(:first, :order => 'RAND()').id
      
      if rand(1) == 1
        i.situational = 1
      else
        i.best_in_slot = rand(1)
      end
    end
  end
end