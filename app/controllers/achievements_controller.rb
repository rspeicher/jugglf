class AchievementsController < ApplicationController
  caches_action :index, :layout => false # NOTE: Gets 'expired' (deleted) by achievements.rake
  
  def index
    page_title('Achievements')
    
    @achievements = Achievement.find(:all, :order => 'title', 
      :conditions => ['category_id = ?', 168])
    @members = Member.active.find(:all, :include => :achievements)
    
    respond_to do |wants|
      wants.html
    end
  end
end
