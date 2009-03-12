class SearchController < ApplicationController
  def index
    @include_fields = [:id, :name, :wow_class, :created_at, :updated_at]
    
    @query = params[:query]
    @field = :name
    split_query
    
    @field = :wow_class if @field == :class
    @field = :name unless @include_fields.include? @field
    
    case params[:context]
    when 'members'
      @results = Member.active.search(@field => "%#{@query}%", :order => 'name')
    when 'items'
      @results = Item.search(:name => "%#{@query}%", :order => 'name')
    end
    
    respond_to do |wants|
      wants.html { redirect_to(polymorphic_path(@results[0])) }
      wants.js { render :json => @results.to_json(:only => @include_fields) }
      wants.xml { render :xml => @results.to_xml(:only => @include_fields) }
    end
  end
  
  private
    def split_query
      @query.scan(/^(.+):(.+)$/) do |k,v|
        @query = v
        @field = k.downcase.intern
      end
    end
end
