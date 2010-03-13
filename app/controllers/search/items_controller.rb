class Search::ItemsController < ApplicationController
  INCLUDED_FIELDS = [:id, :name, :slot, :level, :color, :icon, :heroic, :authentic, :loots_count, :wishlists_count].freeze

  def index
    params[:q] = "INVALIDSEARCH" if params[:q].blank? # Bit of a hack to prevent searching the entire database if no input was given
    params[:q].gsub!(' ', '%')

    scope = Item.name_like(params[:q])

    respond_to do |wants|
      wants.html do
        if scope.count == 1
          redirect_to item_path(scope.first)
        else
          @items = scope.all(:order => 'name').paginate(:page => params[:page])
          render :template => 'items/index'
        end
      end
      wants.js { render :json => scope.all.to_json(:only => INCLUDED_FIELDS) }
      wants.json { render :json => scope.all.to_json(:only => INCLUDED_FIELDS) }
      wants.xml { render :xml => scope.all.to_xml(:only => INCLUDED_FIELDS) }
    end
  end
end
