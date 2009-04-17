namespace :juggernaut do
  desc "Update achievement cache"
  task :achievements => [:environment] do
    Member.active.each do |member|
      puts "Processing #{member.name}"
      CompletedAchievement.parse_member(member)
    end

    # Surely there's a better way to do this, but whatever.
    FileUtils.rm_rf(Dir['tmp/cache/views/*/achievements*'])
  end
  
  desc "Update LF Cache"
  task :lootfactors => [:environment] do
    Member.update_cache(:all)
    
    # Surely there's a better way to do this, but whatever.
    FileUtils.rm_rf(Dir['tmp/cache/views/*/index*'])
  end

  desc "Update Loot prices based on ItemPrice values"
  task :prices => [:environment] do
    ip = Juggy::ItemPrice.instance
    Loot.find_each(:conditions => "purchased_on > '2008-01-01'") do |loot|
      if loot.item_stat.nil?
        puts "Critical: #{loot.item.name} does not have an ItemStat record; will not be able to determine price"
      else
        wow_class = ( loot.member_id.nil? ) ? nil : loot.member.wow_class
        new_price = ip.price(:name => loot.item.name, :slot => loot.item_stat.slot,
          :level => loot.item_stat.level, :class => wow_class)

        loot.update_attributes(:price => new_price)
      end
    end
  end
end