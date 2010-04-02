# A model that can calculate various stats for use by IndexController
class IndexStat
  # Returns an array of [Class(String), Count(Integer)], depending on the @scope@
  #
  # scope = :active - only count active members
  def self.class_counts(scope = nil)
    if scope == :active
      Member.active.with_class.count(:group => 'wow_class')
    else
      Member.with_class.count(:group => 'wow_class')
    end
  end

  def self.attendance_average(group = :class)
    if group == :guild
      Member.active.find(:first, :conditions => 'wow_class IS NOT NULL',
        :select => 'AVG(attendance_30) AS avg_30, AVG(attendance_90) AS avg_90, AVG(attendance_lifetime) AS avg_lifetime')
    else
      Member.active.find(:all, :conditions => 'wow_class IS NOT NULL', :order => 'wow_class', :group => 'wow_class',
        :select => 'wow_class, AVG(attendance_30) AS avg_30, AVG(attendance_90) AS avg_90, AVG(attendance_lifetime) AS avg_lifetime')
    end
  end

  def self.loot_factor_average(group = :class)
    if group == :guild
      Member.active.find(:first, :conditions => 'wow_class IS NOT NULL',
        :select => 'AVG(lf) AS avg_lf, AVG(sitlf) AS avg_sitlf, AVG(bislf) AS avg_bislf')
    else
      Member.active.find(:all, :conditions => 'wow_class IS NOT NULL', :order => 'wow_class', :group => 'wow_class',
        :select => 'wow_class, AVG(lf) AS avg_lf, AVG(sitlf) AS avg_sitlf, AVG(bislf) AS avg_bislf')
    end
  end

  # Returns an array of 10 Member objects, ordered by first_raid
  def self.oldest_members
    Member.active.find(:all, :order => "first_raid", :limit => 10,
      :conditions => "first_raid IS NOT NULL")
  end

  # SQL conditions for items that should NOT be included in the 'Common Drop' list
  ITEM_CONDITIONS = [
    "name NOT REGEXP '.+ of the (Fallen|Lost|Forgotten|Wayward) ([^\s]+)$'",
    "name NOT LIKE 'Regalia of the Grand %'",
    "name NOT LIKE '% Mark of Sanctification'",
    "name != 'Trophy of the Crusade'",
    "name NOT LIKE 'Qiraji Bindings of%'",
    "name != 'Vek''nilash''s Circlet'",
    "name != 'Vek''lor''s Diadem'",
    "name NOT LIKE '%of the Old God'",
    "(name NOT LIKE 'Desecrated %' OR name = 'Desecrated Past')", # T3 tokens were 'Desecrated (.+)', but not Desecrated Past

    # The following conditions get removed in @self.common_tokens@
    "name != 'Splinter of Atiesh'",
    "name != 'Fragment of Val''anyr'",
    "name != 'Shadowfrost Shard'",
    "name != 'Onyxia Hide Backpack'",
  ]
  # SQL conditions for items that SHOULD be included in the Tier Token list
  TIER_CONDITIONS = ITEM_CONDITIONS.map { |c| c.gsub(" NOT ", ' ').gsub("!=", '=') }

  # Returns an array of 10 Item objects, ordered by the most looted
  #
  # Automatically omits token items.
  def self.common_items
    Item.find(:all, :order => "loots_count DESC",
      :limit => 10, :conditions => ITEM_CONDITIONS.join(' AND '))
  end

  # Returns an array of 10 Item objects, ordered by the most looted
  #
  # Only includes token items.
  def self.common_tokens
    Item.find(:all, :order => "loots_count DESC",
      :limit => 10, :conditions => TIER_CONDITIONS[0..-5].join(' OR '))
  end

  def self.most_requested
    Wishlist.count(:group => 'item_id', :order => "count_all DESC", :limit => 10,
      :conditions => ['priority = ? or priority = ?', 'best in slot', 'normal'])
  end

  # Returns an ordered array of [Class(String), Value(Float)] where
  # Value is the percentage of that class that has been declined.
  def self.least_recruitable
    ret = []

    # Find the total number of members in the database, by class
    totals = self.class_counts

    # Find the total number of declined applicants in the database, by class
    rank = MemberRank.find_by_name('Declined Applicant')
    if rank
      declined = Member.with_class.count(:group => 'wow_class',
        :conditions => ['rank_id = ?', rank.id])

      totals.each do |total_class, total|
        declined.each do |declined_class, count|
          ret.push([declined_class, count.to_f/total.to_f]) if declined_class == total_class
        end
      end
    end

    ret.sort { |x,y| y[1] <=> x[1] }
  end

  # Returns an ordered array of [Class(String), Value(Float)] where
  # Value is the percentage of that class that is Inactive.
  def self.highest_turnover
    ret = []

    # Find the total number of members in the database, by class
    totals = self.class_counts

    # Find the total number of declined applicants in the database, by class
    rank = MemberRank.find_by_name('Inactive')
    if rank
      inactive = Member.with_class.count(:group => 'wow_class',
        :conditions => ['rank_id = ?', rank.id])

      totals.each do |total_class, total|
        inactive.each do |inactive_class, count|
          ret.push([inactive_class, count.to_f/total.to_f]) if inactive_class == total_class
        end
      end
    end

    ret.sort { |x,y| y[1] <=> x[1] }
  end

  # Returns an array of 10 Member objects, where Member.loots_per_raid is
  # loots_count/raids_count
  def self.loots_per_raid
    Member.active.find(:all, :conditions => 'raids_count > 0',
      :select => "id, name, wow_class, (loots_count/raids_count) AS loots_per_raid",
      :order => "loots_per_raid DESC", :limit => 10)
  end

  def self.fragment_progress
    Loot.count(:all, :group => 'member_id', :conditions => ['item_id = ?', 45038])
  end

  def self.shadowmourne_progress
    Loot.count(:all, :group => 'member_id', :conditions => ['item_id = ?', 50274])
  end

  def self.best_attendance
    Member.active.find(:all, :conditions => ["first_raid <= ?", 6.months.until(Date.today)],
      :order => 'attendance_lifetime DESC', :limit => 10)
  end

  # Returns an ordered array of [Member(Member), Value(Float)] where
  # Value is total_loots divided by the number of days they have been raiding
  # NOTE: This ended up being uninteresting
  # def self.loots_per_day
  #   #(Date1 - Date2).to_i
  #   today = Date.today
  #
  #   ret = []
  #   Member.active.find(:all, :conditions => 'first_raid <> last_raid', :order => 'name').each do |member|
  #     days = (member.last_raid - member.first_raid).to_i
  #     ret.push([member, member.loots_count.to_f/days.to_f])
  #   end
  #
  #   # return ret[0..9]
  #   ret.sort { |x,y| y[1] <=> x[1] }[0..9]
  # end
end
