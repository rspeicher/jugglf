# A model that can calculate various stats for use by IndexController
class IndexStat
  def self.class_counts(scope = nil)
    if scope == :active
      Member.active.with_class.count(:group => 'wow_class')
    else
      Member.with_class.count(:group => 'wow_class')
    end
  end
  
  # Returns an ordered array of [Class(String), Value(Float)] where 
  # Value is the percentage of that class that has been declined.
  def self.least_recruitable
    # Find the total number of members in the database, by class
    totals = self.class_counts
    
    # Find the total number of declined applicants in the database, by class
    rank = MemberRank.find_by_name('Declined Applicant')
    declined = Member.with_class.count(:group => 'wow_class', 
      :conditions => ['rank_id = ?', rank.id])
      
    ret = []
    totals.each do |total_class, total|
      declined.each do |declined_class, count|
        ret.push([declined_class, count.to_f/total.to_f]) if declined_class == total_class
      end
    end
    
    ret.sort { |x,y| y[1] <=> x[1] }
  end
  
  # Returns an array of Member rows, where row.loots_per_raid is loots_count/raids_count
  def self.loots_per_raid
    Member.active.find(:all, :conditions => 'raids_count > 0', 
      :select => "name, wow_class, (loots_count/raids_count) AS loots_per_raid",
      :order => "loots_per_raid DESC", :limit => 10)
  end
  
  # Returns an ordered array of [Member(Member), Value(Float)] where
  # Value is total_loots divided by the number of days they have been raiding
  # This ended up being uninteresting
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
