class Members::AchievementsController < ApplicationController
  before_filter :require_user_with_member
  
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
      if current_user.is_admin?
        @parent = @member = Member.find(params[:member_id])
      else
        # Scope to the current user
        @parent = @member = current_user.member
      end
    end
end
