class WishlistsController < ApplicationController
  before_filter :require_user
  
  # before_filter :find_parent, :only => [:show, :edit, :update, :destroy]
  
  def new
    @wishlist = Wishlist.new
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def create
    @wishlist = Wishlist.new(params[:wishlist].
      merge!(:member_id => Member.find_by_name('Tsigo').id)) # TODO: Current user's member id
      
    respond_to do |wants|
      wants.html do
        if @wishlist.save
          flash[:success] = "Wishlist entry was added successfully."
          redirect_to(member_path(@wishlist.member_id))
        else
          wants.html { render :action => 'new' }
          wants.js
        end
      end
      wants.js do
        logger.info "Item Name: #{@wishlist.item_name}"
        if @wishlist.save
          render :update do |page|
            page[:errors].hide
            page.insert_html(:bottom, 'wishlist_rows', :partial => 'members/wishlist_row', :object => @wishlist)
          end
        else
          render :update do |page|
            page.visual_effect(:blind_down, :errors)
            page.replace_html :errors, @wishlist.errors.full_messages.join('<br/>')
          end
        end
      end
    end
  end
  
  private
    def find_parent
      if params[:member_id]
        @parent = @member = Member.find(params[:member_id])
      end
    end
end
