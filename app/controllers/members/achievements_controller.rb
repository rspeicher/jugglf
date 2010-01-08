class Members::AchievementsController < ApplicationController
  # TODO: Permissions?
  before_filter :require_user
  
  before_filter :find_parent
  
  def index
    @achievements = Achievement.find(:all, :include => [:completed_achievements], :order => 'title')
    @completed = @member.completed_achievements
    
    respond_to do |wants|
      wants.html
    end
  end
  
  private
    def find_parent
      @parent = @member = Member.find(params[:member_id])
    end
end
