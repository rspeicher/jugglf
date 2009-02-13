# == Schema Information
# Schema version: 20090208213027
#
# Table name: items
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  price        :float           default(0.0)
#  situational  :boolean(1)
#  best_in_slot :boolean(1)
#  member_id    :integer(4)
#  raid_id      :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  rot          :boolean(1)
#

class Item < ActiveRecord::Base
  # Relationships -------------------------------------------------------------
  # NOTE: counter_cache with non-has_many :through assocations and the << operator is FUCKING BUGGY AS SHIT
  # See https://gist.github.com/862e344f8ec10995de66
  belongs_to :member#, :counter_cache => true
  belongs_to :raid#, :counter_cache => true
  alias_method :buyer, :member
  
  # Class Methods -------------------------------------------------------------
  def self.from_attendance_output(line)
    split = line.split(" - ")
    return unless split.length == 2
    
    retval = []
    
    buyer_side = split[0].split(",")
    item_side  = split[1].gsub(/\[(.+)\]/, '\1').strip # Item name, no brackets
    
    buyer_side.each do |buyer|
      item = Item.new
      
      buyer = buyer.strip
      
      # These next regex just mean "contained within parenthesis where the only
      # other values are a-z and \s"; Prevents "Tsitgo" as a name from 
      # matching "sit" as a tell type while still allowing "(bis rot)"
      item.situational  = !buyer.match(/\(([a-z\s]+)?sit([a-z\s]+)?\)/).nil?
      item.best_in_slot = !buyer.match(/\(([a-z\s]+)?bis([a-z\s]+)?\)/).nil?
      item.rot          = !buyer.match(/\(([a-z\s]+)?rot([a-z\s]+)?\)/).nil?
      
      # Item name and buyer
      unless buyer == 'DE'
        member = Member.find_or_initialize_by_name(buyer.gsub(/^([A-Za-z]+).*?$/, '\1'))
        member.uncached_updates += 1
        item.member = member
      end
      
      item.name   = item_side
      
      price = item.determine_item_price()
      if price.is_a? Float
        item.price = price
      else
        # item.price = 99999.00 # FIXME: How do we tell the user that we couldn't determine the price for this item?
        item.price = price[0] # NOTE: Just assuming the higher cost for now
      end
      
      retval.push(item)
    end
    
    retval
  end
  
  # Instance Methods ----------------------------------------------------------
  def affects_loot_factor?
    self.raid.date >= 8.weeks.ago.to_datetime if self.raid
  end
  
  def adjusted_price
    ( self.rot? ) ? 0.50 : self.price
  end
  
  def determine_item_price
    ItemPrice.new.price(ItemStat.lookup_by_name(self.name), buyer_is_hunter?)
  end
  
  private
    def buyer_is_hunter?
      self.buyer and self.buyer.wow_class == 'Hunter'
    end
end