class Members::LootsController < ApplicationController
  # TODO: Permissions?
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
      @parent = @member = Member.find(params[:member_id])
    end
end
