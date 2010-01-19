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
    # 2009-04-14 was the 3.1 patch release;
    # 45038 is the Fragment of Val'anyr ID, which we don't want to re-price since some of them have to be 5.00
    Loot.find_each(:conditions => ["purchased_on > ? AND item_id != ?", '2009-04-14', 45038]) do |loot|
      if loot.item.wow_id.nil?
        puts "Critical: #{loot.item.name} does not have a valid Item record; will not be able to determine price"
      else
        # If an item was DE'd, we don't give it a value
        if loot.member_id.nil?
          new_price = nil
        else
          wow_class = ( loot.member_id.nil? ) ? nil : loot.member.wow_class
          new_price = ip.price(:name => loot.item.name, :slot => loot.item.slot,
            :level => loot.item.level, :class => wow_class)
        end

        # Only update the price if it changed
        if loot.price != new_price
          loot.update_attribute(:price, new_price)
        end
      end
    end
  end

  desc "Cleanup Items that may have been erroneously entered"
  task :cleanup => [:environment] do
  end
end