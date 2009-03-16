class SearchController < ApplicationController
  def index
    @include_fields = [:id, :name, :wow_class, :active, :loots_count, 
      :wishlists_count, :raid_count, :created_at, :updated_at]
    
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
      @results = @members = Member.search(@field => "%#{@query}%", :order => 'name', 
        :per_page => 999)
    when 'items'
      @results = @items = Item.search(:name => "%#{@query}%", :order => 'name',
        :page => params[:page])
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
      wants.ac { render :text => @results.collect { |x| x.name }.join("\n") }
    end
  end
end
