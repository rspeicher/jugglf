class IndexController < ApplicationController
  caches_action :index, :layout => false # NOTE: Gets 'expired' (deleted) by updatelf.rake

  def index
    # Number of members in guild, number in each class
    @count_guild = Member.active.count
    @counts      = IndexStat.class_counts(:active)

    # Attendance averages
    @attendance_guild = IndexStat.attendance_average(:guild)
    @attendance       = IndexStat.attendance_average(:class)
    @lootfactor_guild = IndexStat.loot_factor_average(:guild)
    @lootfactor       = IndexStat.loot_factor_average(:class)

    @stat_groups = [
      # Partial                  Object
      [ 'common_items',          IndexStat.common_items ],
      [ 'common_tokens',         IndexStat.common_tokens ],
      [ 'most_wishlists',        IndexStat.most_requested ],
      [ 'loots_per_raid',        IndexStat.loots_per_raid ],
      [ 'oldest_members',        IndexStat.oldest_members ],
      [ 'best_attendance',       IndexStat.best_attendance ],
      [ 'worst_recruits',        IndexStat.least_recruitable ],
      [ 'highest_turnover',      IndexStat.highest_turnover ],
      [ 'shadowmourne_progress', IndexStat.shadowmourne_progress ], # FIXME: Item not found error in new installation
    ]

    respond_to do |wants|
      wants.html
    end
  end
end
