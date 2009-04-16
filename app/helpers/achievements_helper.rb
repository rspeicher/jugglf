module AchievementsHelper
  def achievement_icon(ach)
    link_to(image_tag("http://static.wowhead.com/images/icons/small/#{ach.icon}.jpg",
      :size => "10x10"), 
      "http://www.wowhead.com/?achievement=#{ach.armory_id}")
  end
end
