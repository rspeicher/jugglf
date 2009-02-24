namespace :db do
  namespace :legacy do
    desc "Convert the legacy Juggernaut EQdkp tables to the new format"
    task :convert => [:environment] do
      [Attendee, Item, Member, Raid].each(&:delete_all)
    
      LegacyMember.all.each do |lm|
        m = Member.find_or_initialize_by_name(lm.name)
        m.active              = lm.active
        m.first_raid          = lm.first_raid
        m.last_raid           = lm.last_raid
        m.raids_count         = lm.raids_count
        m.wow_class           = lm.wow_class
        m.lf                  = lm.lf
        m.sitlf               = lm.sitlf
        m.bislf               = lm.bislf
        m.attendance_30       = lm.attendance_30
        m.attendance_90       = lm.attendance_90
        m.attendance_lifetime = lm.attendance_lifetime
      
        m.save!
      end
    
      LegacyRaid.all.each do |lr|
        r = Raid.new
        r.date   = lr.date
        r.note   = lr.note
        r.thread = lr.thread
        
        r.update_attendee_cache = false # Otherwise this would be sloooooooooow
        r.save!
      
        # Use the legacy raid's ID to lookup its attendance, but don't create its
        # Attendee record using that ID or we've got problems
        LegacyAttendee.find_all_by_raid_id(lr.raid_id).each do |la|
          r.attendees.create(:member_id => la.member_id, :attendance => la.attendance)
        end
      
        # r.attendees_count = r.attendees.length
        r.reload
      
        # Lookup items by the LEGACY raid ID
        LegacyItem.find_all_by_raid_id(lr.raid_id).each do |li|
          i = { }
          i[:name]         = li.name
          i[:price]        = li.price
          i[:situational]  = li.situational?
          i[:best_in_slot] = li.best_in_slot?
          i[:member_id]    = li.member_id
          i[:rot]          = li.rot?
        
          r.items.create(i)
        end
      
        # Save one more time to make sure the items get saved
        r.update_attendee_cache = false # Otherwise this would be sloooooooooow
        r.save!
      end
    
      Member.update_all_cache
    end
  end
end