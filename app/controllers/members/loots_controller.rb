class Members::LootsController < ApplicationController
  before_filter :require_user
  
  before_filter :find_parent
  
  def index
    @loots = @member.loots.paginate(:page => params[:page], :per_page => 35, :include => :item)
      
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
        require_admin if @parent.nil?
      end
    end
end
