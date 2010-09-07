class SearchesController < ApplicationController
  before_filter :normalize_context
  before_filter :normalize_query

  def show
    # :context is sanitized by normalize_context, so no injection worry
    send("search_#{params[:context]}")
  end

  private

  def normalize_context
    unless %w(members items).include? params[:context]
      params[:context] = 'members'
    end
  end

  def normalize_query
    # Bit of a hack to prevent searching the entire database if no input was given
    params[:q] = "INVALIDSEARCH" if params[:q].blank?
  end

  def search_members
    included_fields = [:id, :name, :first_raid, :last_raid, :active, :loots_count, :wishlists_count, :raid_count].freeze

    if Member::WOW_CLASSES.include? params[:q]
      scope = Member.active.of_class(params[:q])
    else
      scope = Member.search(:name_contains => params[:q])
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
      wants.js { render :json => scope.all.to_json(:only => included_fields) }
      wants.json { render :json => scope.all.to_json(:only => included_fields) }
      wants.xml { render :xml => scope.all.to_xml(:only => included_fields) }
    end
  end

  def search_items
    included_fields = [:id, :name, :slot, :level, :color, :icon, :heroic, :authentic, :loots_count, :wishlists_count].freeze

    # Allow partial name matches ('conq sanc' will match "Conqueror's Mark of Sanctification")
    params[:q].gsub!(' ', '%')

    scope = Item.limit(50).search(:name_contains => params[:q])

    respond_to do |wants|
      wants.html do
        if scope.count == 1
          redirect_to item_path(scope.first)
        else
          @items = scope.all(:order => 'name').paginate(:page => params[:page])
          render :template => 'items/index'
        end
      end
      wants.js { render :json => scope.all.to_json(:only => included_fields) }
      wants.json { render :json => scope.all.to_json(:only => included_fields) }
      wants.xml { render :xml => scope.all.to_xml(:only => included_fields) }
    end
  end
end
