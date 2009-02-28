namespace :db do
  namespace :legacy do
    desc "Convert the legacy Juggernaut EQdkp tables to the new format"
    task :convert => [:environment] do
      [Attendee, Item, Loot, MemberRank, Member, Punishment, Raid].each(&:delete_all)
      
      def member_rank(legacy)
        rank = MemberRank.find_or_initialize_by_name(legacy.rank_name)
        if rank.new_record?
          rank.prefix = legacy.rank_prefix
          rank.suffix = legacy.rank_suffix
          rank.save!
        end
        
        rank.id
      end
    
      LegacyMember.all.each do |lm|
        m = Member.find_or_initialize_by_name(lm.name)
        m.active              = lm.active
        m.wow_class           = lm.wow_class
        m.lf                  = lm.lf
        m.sitlf               = lm.sitlf
        m.bislf               = lm.bislf
        m.attendance_30       = lm.attendance_30
        m.attendance_90       = lm.attendance_90
        m.attendance_lifetime = lm.attendance_lifetime
        m.rank_id             = member_rank(LegacyMemberRank.find_by_rank_id(lm.rank_id))
      
        m.save!
      end
    
      LegacyRaid.all.each do |lr|
        r = Raid.new
        r.date   = lr.date
        r.note   = lr.note
        r.thread = lr.thread
        
        r.update_cache = false # Otherwise this would be sloooooooooow
        r.save(false)
      
        # Use the legacy raid's ID to lookup its attendance, but don't create its
        # Attendee record using that ID or we've got problems
        LegacyAttendee.find_all_by_raid_id(lr.raid_id).each do |la|
          r.attendees.create(:member_id => la.member_id, :attendance => la.attendance)
        end
      
        # Lookup items by the LEGACY raid ID
        LegacyItem.find_all_by_raid_id(lr.raid_id).each do |li|
          loot = { }
          loot[:item]         = Item.find_or_create_by_name(li.name)
          loot[:price]        = li.price
          loot[:situational]  = li.situational?
          loot[:best_in_slot] = li.best_in_slot?
          loot[:member_id]    = li.member_id
          loot[:rot]          = li.rot?
          loot[:purchased_on] = r.date
        
          r.loots.create(loot)
        end
      
        # Save one more time to make sure the items get saved
        r.update_cache = false # Otherwise this would be sloooooooooow
        r.save(false)
      end
    
      Member.update_all_cache
    end
  end
end