class Members::RaidsController < ApplicationController
  # TODO: Permissions?
  before_filter :require_user
  
  before_filter :find_parent
  
  def index
    # We're intentionally finding all raids here, not just those that this member attended
    @raids = Raid.paginate(:page => params[:page], :per_page => 35, 
      :include => [:attendees], :order => "date DESC")
      
    respond_to do |wants|
      wants.html
    end
  end
  
  private
    def find_parent
      @parent = @member = Member.find(params[:member_id])
    end
end
