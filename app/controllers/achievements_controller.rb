class AchievementsController < ApplicationController
  caches_action :index, :layout => false # NOTE: Gets 'expired' (deleted) by achievements.rake
  
  def index
    page_title('Achievements')
    
    included = [ 3057, 2929, 2924, 3059, 2944, 2954, 3007, 3184, 3183, 3187, 
      3189, 3188, 3163 ]
    
    @achievements = Achievement.find(:all, :order => 'armory_id', 
      :conditions => ["category_id = ? AND armory_id IN (#{included.join(',')})", 168])
    @members = Member.active.find(:all, :include => :achievements)
    
    respond_to do |wants|
      wants.html
    end
  end
end
