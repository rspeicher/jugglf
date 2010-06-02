class IndexSweeper < ActionController::Caching::Sweeper
  observe Loot, Member, Raid, Wishlist

  def after_create(record)
    if record.is_a? Loot
      if record.item_id == 50274 # NOTE: Hard-coded Shadowfrost Shard ID
        expire 'shadowmourne_progress'
      else
        expire_loot_fragments
      end
    elsif record.is_a? Member
      expire_member_fragments
    elsif record.is_a? Raid
      expire_raid_fragments
    elsif record.is_a? Wishlist
      expire_wishlist_fragments
    end
  end

  def after_update(record)
    if record.is_a? Loot
      expire_loot_fragments
    elsif record.is_a? Member
      expire_member_fragments

      unless record.active?
        expire 'least_recruitable'
        expire 'highest_turnover'
      end
    elsif record.is_a? Raid
      expire_raid_fragments
    elsif record.is_a? Wishlist
      expire_wishlist_fragments
    end
  end

  def after_destroy(record)
    if record.is_a? Loot
      expire_loot_fragments
    elsif record.is_a? Member
      expire_member_fragments
    elsif record.is_a? Raid
      expire_raid_fragments
    elsif record.is_a? Wishlist
      expire_wishlist_fragments
    end
  end

  protected

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

    def expire_loot_fragments
      expire 'loot_factor_averages'
      expire 'common_items'
      expire 'common_tokens'
    end

    def expire_member_fragments
      expire 'class_counts'
      expire 'attendance_averages'
      expire 'loot_factor_averages'
      expire 'loots_per_raid'
      expire 'oldest_members'
      expire 'best_attendance'
    end

    def expire_raid_fragments
      expire 'attendance_averages'
      expire 'loot_factor_averages'
      expire 'loots_per_raid'
      expire 'best_attendance'
    end

    def expire_wishlist_fragments
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
