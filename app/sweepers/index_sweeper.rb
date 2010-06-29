class IndexSweeper < ActionController::Caching::Sweeper
  observe Loot, Member, Raid, Wishlist

  def after_create(record)
    process_record(record)
  end

  def after_update(record)
    process_record(record)
  end

  def after_destroy(record)
    process_record(record)
  end

  protected

    def process_record(record)
      record_type = record.class.to_s.underscore
      send("expire_#{record_type}_fragments", record)
    rescue NoMethodError
      logger.warn "Attempted to expire fragments for unknown record type: #{record_type}"
    end

    # class_counts:          expire when a Member is c/u/d
    # attendance_averages:   expire when a Member or Raid is c/u/d
    # loot_factor_averages:  expire when a Member, Raid or Loot is c/u/d
    # common_items:          expire when Loot is c/u/d
    # common_tokens:         expire when Loot is c/u/d
    # most_requested:        expire when Wishlist is c/u/d
    # loots_per_raid:        expire when Member or Raid is c/u/d
    # oldest_members:        expire when Member is c/u/d
    # best_attendance:       expire when Member or Raid is c/u/d
    # least_recruitable:     expire when a Member is updated and marked as Declined
    # highest_turnover:      expire when a Member is updated and marked as Inactive
    # shadowmourne_progress: expire when a Loot with its ID is created

    def expire_loot_fragments(loot)
      if loot.item_id == 50274 # Item.shadowfrost_shard.first.id # FIXME: Can't use because of specs
        expire 'shadowmourne_progress'
      else
        expire 'loot_factor_averages'
        expire 'common_items'
        expire 'common_tokens'
      end
    end

    def expire_member_fragments(member)
      expire 'class_counts'
      expire 'attendance_averages'
      expire 'loot_factor_averages'
      expire 'loots_per_raid'
      expire 'oldest_members'
      expire 'best_attendance'

      unless member.active?
        expire 'least_recruitable'
        expire 'highest_turnover'
      end
    end

    def expire_raid_fragments(raid)
      expire 'attendance_averages'
      expire 'loot_factor_averages'
      expire 'loots_per_raid'
      expire 'best_attendance'
    end

    def expire_wishlist_fragments(wishlist)
      # NOTE: Because we namespace to Members::WishlistsController, we get the following error:
      # ActionController::RoutingError (No route matches {:action=>"index", :action_suffix=>"most_requested", :controller=>"members/index"})
      # expire 'most_requested'

      # Make a special call to expire_fragment
      expire_fragment(/most_requested/)
    end

    def expire(suffix)
      expire_fragment(:controller => 'index', :action => 'index', :action_suffix => suffix)
    end
end
