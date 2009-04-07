class IndexController < ApplicationController
  caches_action :index, :layout => false # NOTE: Gets 'expired' (deleted) by updatelf.rake
  
  def index
    # Number of members in guild, number in each class
    @count_guild = Member.active.count
    @counts = IndexStat.class_counts(:active)
    
    # Attendance averages
    @attendance_guild = Member.active.find(:first, :conditions => 'wow_class IS NOT NULL',
      :select => 'AVG(attendance_30) AS avg_30, AVG(attendance_90) AS avg_90, AVG(attendance_lifetime) AS avg_lifetime')
    @attendance = Member.active.find(:all, :conditions => 'wow_class IS NOT NULL', :order => 'wow_class', :group => 'wow_class', 
      :select => 'wow_class, AVG(attendance_30) AS avg_30, AVG(attendance_90) AS avg_90, AVG(attendance_lifetime) AS avg_lifetime')
    
    # Loot factor averages
    @lootfactor_guild = Member.active.find(:first, :conditions => 'wow_class IS NOT NULL',
      :select => 'AVG(lf) AS avg_lf, AVG(sitlf) AS avg_sitlf, AVG(bislf) AS avg_bislf')
    @lootfactor =   Member.active.find(:all, :conditions => 'wow_class IS NOT NULL', :order => 'wow_class', :group => 'wow_class', 
      :select => 'wow_class, AVG(lf) AS avg_lf, AVG(sitlf) AS avg_sitlf, AVG(bislf) AS avg_bislf')
      
    normal_conditions = [
      "name NOT REGEXP '.+ of the (Fallen|Lost|Forgotten) ([^\s]+)$'",
      "name NOT LIKE 'Qiraji Bindings of%'",
      "name != 'Vek''nilash''s Circlet'",
      "name != 'Vek''lor''s Diadem'",
      "name NOT LIKE '%of the Old God'",
      "(name NOT LIKE 'Desecrated %' OR name = 'Desecrated Past')",
      
      # The following conditions get removed from the tokens query
      "name != 'Splinter of Atiesh'",
    ]
    tier_conditions = normal_conditions.map { |c| c.gsub(" NOT ", ' ').gsub("!=", '=') }
    
    common_items     = Item.find(:all, :include => :loots, :order => "loots_count DESC",
      :limit => 10, :conditions => normal_conditions.join(' AND '))
    common_tokens    = Item.find(:all, :include => :loots, :order => "loots_count DESC",
      :limit => 10, :conditions => tier_conditions[0..-2].join(' OR '))
    most_wishlists = Item.find(:all, :order => "wishlists_count DESC", :limit => 10)
    oldest_members   = Member.active.find(:all, :order => "first_raid", :limit => 10)
      
    @stat_groups = {
      :common_items   => { :data => common_items,   :header => 'Most Common Items' },
      :common_tokens  => { :data => common_tokens,  :header => 'Most Common Tier Tokens' },
      :most_wishlists => { :data => most_wishlists, :header => 'Most Wanted Items' },
      :oldest_members => { :data => oldest_members, :header => 'Oldest Active Members' },
      :worst_recruits => { :data => IndexStat.least_recruitable, :header => 'Least Recruitable Class' },
      :loots_per_raid => { :data => IndexStat.loots_per_raid,    :header => 'Most Loots Per Raid' },
    }
    
    respond_to do |wants|
      wants.html
    end
  end
end
