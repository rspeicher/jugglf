require 'open-uri'
require 'nokogiri'

class CompletedAchievement < ActiveRecord::Base
  attr_accessible :member, :member_id, :achievement, :achievement_id, :completed_on

  belongs_to :achievement
  belongs_to :member

  validates_presence_of :achievement
  validates_presence_of :member

  def self.parse_member(member)
    total_achievements = Achievement.count

    if total_achievements == 0 or member.completed_achievements.count != total_achievements
      contents = open("http://www.wowarmory.com/character-achievements.xml?r=Mal%27Ganis&n=#{member.name}&c=168", {
        'User-Agent'      => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_4; en-US) AppleWebKit/534.3 (KHTML, like Gecko) Chrome/6.0.472.53 Safari/534.3",
        'Accept-language' => 'enUS'
      })
      doc = Nokogiri::XML(contents)

      # 6th Category = Lich King Heroic Raid
      # 8th Category = Secrets of Ulduar Heroic
      # 12th Category = Fall of the Lich King 25
      doc.search("category:nth(12) achievement").each do |ach|
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
end
