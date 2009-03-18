require 'open-uri'
require 'nokogiri'

namespace :jugg do
  desc "Update achievement cache"
  task :achievements => [:environment] do
    total_achievements = Achievement.count
    
    Member.active.each do |member|
      unless member.completed_achievements.count == total_achievements
        puts "Processing achievements for #{member.name}"
        contents = open("http://www.wowarmory.com/character-achievements.xml?r=Mal%27Ganis&n=#{member.name}&c=168",
          'User-Agent'      => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.0.7) Gecko/2009021906 Firefox/3.0.7",
          'Accept-language' => 'enUS'
        )
        doc = Nokogiri::XML(contents)
      
        # 6th Category = Lich King Heroic Raid
        doc.search("category:nth(6) achievement").each do |ach|
          achievement = Achievement.find_or_initialize_by_armory_id(ach['id'])
        
          if achievement.new_record?
            achievement.armory_id   = ach['id']
            achievement.category_id = ach['categoryId']
            achievement.title       = ach['title']
            achievement.icon        = ach['icon']
            achievement.save
          end
        
          if ach['dateCompleted'] and (not achievement.members.include? member)
            achievement.completed_achievements.create(:member => member, 
              :completed_on => ach['dateCompleted'])
          end
        end
      end
    end
    
    # Surely there's a better way to do this, but whatever.
    FileUtils.rm_rf(Dir['tmp/cache/views/*/achievements*'])
  end
end