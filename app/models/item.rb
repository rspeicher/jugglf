# == Schema Information
# Schema version: 20090113041939
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
#

class Item < ActiveRecord::Base
  # NOTE: counter_cache with non-has_many :through assocations and the << operator is FUCKING BUGGY AS SHIT
  # See https://gist.github.com/862e344f8ec10995de66
  belongs_to :member#, :counter_cache => true
  belongs_to :raid#, :counter_cache => true
  alias_method :buyer, :member
  
  def self.from_attendance_output(value)
    split = value.split(" - ")
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
      
      # TODO: Lookup item price based on our pricing structure and Wowhead data
      # item.price = ...
      
      retval.push(item)
    end
    
    retval
  end
  
  def affects_loot_factor?
    self.raid.date >= 8.weeks.ago.to_datetime if self.raid
  end
  
  def adjusted_price
    ( self.rot? ) ? 0.50 : self.price
  end
end
