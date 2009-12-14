class SearchController < ApplicationController
  def index
    @include_fields = [:id, :name, :wow_id, :slot, :level, :color, :icon, :wow_class, :heroic,
      :active, :loots_count, :wishlists_count, :raid_count]
    
    params[:query] = params[:q] unless params[:q].nil? # jquery.autocomplete uses 'q' and it can't be configured
    
    @query = params[:query]
    @field = :name
    
    # Support setting the field via 'field:value' queries
    @query.scan(/^(.+):(.+)$/) do |k,v|
      @query = v
      @field = k.downcase.intern
    end
    
    @field = :wow_class if @field == :class
    @field = :name unless @include_fields.include? @field
    
    case params[:context]
    when 'members'
      @results = @members = Member.active.search(@field => "%#{@query}%", :order => 'name', 
        :per_page => 999)
    when 'items'
      @results = @items = Item.search_name_or_wow_id(@query, :order => 'name',:page => params[:page])
    end
    
    respond_to do |wants|
      wants.html do
        page_title(params[:context].titlecase, 'Search Results')
        if @results.size == 1
          redirect_to(polymorphic_path(@results[0]))
        else
          render :template => "#{params[:context]}/index"
        end
      end
      wants.js { render :json => @results.to_json(:only => @include_fields) }
      wants.xml { render :xml => @results.to_xml(:only => @include_fields) }
    end
  end
end
