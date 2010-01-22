module AchievementsHelper
  def achievement_icon(ach, options = {})
    options[:size] ||= '18x18'

    link_to(image_tag("http://static.wowhead.com/images/icons/small/#{ach.icon}.jpg",
      :size => options[:size]),
      "http://www.wowhead.com/?achievement=#{ach.armory_id}")
  end
end
