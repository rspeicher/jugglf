class Search::MembersController < ApplicationController
  INCLUDED_FIELDS = [:id, :name, :first_raid, :last_raid, :active, :loots_count, :wishlists_count, :raid_count].freeze

  def index
    params[:q] = "INVALIDSEARCH" if params[:q].blank? # Bit of a hack to prevent searching the entire database if no input was given

    if Member::WOW_CLASSES.include? params[:q]
      scope = Member.wow_class_equals(params[:q]).active # Only active members of this class
    else
      scope = Member.name_like(params[:q])
    end

    respond_to do |wants|
      wants.html do
        if scope.count == 1
          redirect_to member_path(scope.first)
        else
          @members = scope.all(:order => 'name').paginate(:page => params[:page])
          render :template => 'members/index'
        end
      end
      wants.js { render :json => scope.active.all.to_json(:only => INCLUDED_FIELDS) }
      wants.json { render :json => scope.active.all.to_json(:only => INCLUDED_FIELDS) }
      wants.xml { render :xml => scope.active.all.to_xml(:only => INCLUDED_FIELDS) }
    end
  end
end
