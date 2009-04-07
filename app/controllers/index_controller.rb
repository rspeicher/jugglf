class IndexController < ApplicationController
  caches_action :index, :layout => false # NOTE: Gets 'expired' (deleted) by updatelf.rake
  
  def index
    # Number of members in guild, number in each class
    @count_guild = Member.active.count
    @counts = Member.active.count(:group => 'wow_class', :conditions => 'wow_class IS NOT NULL')
    
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
      
    # Top 10 Most Looted Items
    @common_items = Item.find(:all, :include => :loots, :order => "loots_count DESC",
      :limit => 10, :conditions => "#{Item.table_name}.name NOT REGEXP '.+of the (Lost|Forgotten).+'")
    # Top 10 Most Looted Tokens
    @common_tokens = Item.find(:all, :include => :loots, :order => "loots_count DESC",
      :limit => 10, :conditions => "#{Item.table_name}.name REGEXP '.+of the (Lost|Forgotten).+'")
    # Top 10 Most Requested Items
    @common_wishlists = Item.find(:all, :order => "wishlists_count DESC", :limit => 10)
    
    # Oldest Members
    @oldest_members = Member.active.find(:all, :order => "first_raid", :limit => 10)
    
    respond_to do |wants|
      wants.html
    end
  end
end
