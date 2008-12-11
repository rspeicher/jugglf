class MembersController < ApplicationController
  def index
    @members = Member.find(:all, :order => "lf DESC, name ASC")
    
    respond_to do |wants|
      wants.html
    end
  end
end