def member_rank(legacy)
  rank = MemberRank.find_or_initialize_by_name(legacy.rank_name)
  rank.id
end

namespace :db do
  namespace :legacy do
    desc "Convert the Doomhammer Juggernaut EQdkp tables to the new format"
    task :convert_dh => ['convert_dh:members', 'convert_dh:raids'] do
    end
    
    namespace :convert_dh do
      desc "Convert Members"
      task :members => [:environment] do
        # DO NOT delete existing records, we're merging, not doing a fresh import
        # [MemberRank, Member, Punishment].each(&:delete_all)

        DoomhammerMember.all.each do |dm|
          m = Member.find_or_initialize_by_name(dm.name)
          
          # DO NOT update existing records
          if m.new_record?
            m.active              = dm.active
            m.wow_class           = dm.wow_class
            m.rank_id             = member_rank(LegacyMemberRank.find_by_rank_id(dm.rank_id))

            m.save!
          end
        end
      end
      
      desc "Convert Raids"
      task :raids => [:environment] do
        # DO NOT delete existing records
        # [Attendee, Item, Loot, Raid].each(&:delete_all)
        
        DoomhammerRaid.all.each do |dr|
          r = Raid.new
          r.date = dr.date

          r.update_cache = false # Otherwise this would be sloooooooooow
          r.save(false)

          # Use the Doomhammer raid's ID to lookup its attendance, but don't create its
          # Attendee record using that ID or we've got problems
          DoomhammerAttendee.find_all_by_raid_id(dr.raid_id).each do |da|
            r.attendees.create(:member_id => da.member_id, :attendance => da.attendance)
          end

          # Lookup items by the DOOMHAMMER raid ID
          DoomhammerItem.find_all_by_raid_id(dr.raid_id).each do |di|
            loot = { }
            loot[:item]         = Item.find_or_create_by_name(di.name)
            loot[:price]        = di.price
            loot[:situational]  = di.situational?
            #loot[:best_in_slot] = di.best_in_slot? # Didn't exist
            loot[:member_id]    = di.member_id
            loot[:rot]          = di.rot?
            loot[:purchased_on] = r.date

            r.loots.create(loot)
          end

          # Save one more time to make sure the items get saved
          r.update_cache = false # Otherwise this would be sloooooooooow
          r.save(false)
        end
      end
      
      desc "Convert Items"
      task :items => [:environment] do
        puts "Items are converted at the same time as Raids. See db:legacy:convert_dh:raids"
      end
    end
  end
end