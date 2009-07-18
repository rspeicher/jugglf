# == Schema Information
# Schema version: 20090717234345
#
# Table name: items
#
#  id              :integer(4)      not null, primary key
#  name            :string(100)
#  wishlists_count :integer(4)      default(0)
#  loots_count     :integer(4)      default(0)
#  wow_id          :integer(4)
#  color           :string(15)
#  icon            :string(255)
#  level           :integer(4)      default(0)
#  slot            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class Item < ActiveRecord::Base
  # Relationships -------------------------------------------------------------
  has_many :loots, :dependent => :destroy
  has_many :wishlists, :order => 'priority', :dependent => :destroy
  has_many :loot_tables, :as => :object, :dependent => :destroy
  
  # Attributes ----------------------------------------------------------------
  attr_accessible :name, :item_stat, :item_stat_id
  
  searchify :name
  
  # Validations ---------------------------------------------------------------
  validates_presence_of :name
  validates_uniqueness_of :name
  
  # Callbacks -----------------------------------------------------------------
  before_save :use_proper_name
  
  # Class Methods -------------------------------------------------------------
  
  # Moves one item's children from one Item to another to safely handle duplicate
  # item names.
  def self.safely_rename(args = {})
    return if args.length < 2
    return if args[:from].nil? or args[:to].nil?
    
    from = ( args[:from].is_a? String ) ? Item.find_by_name(args[:from]) : Item.find(args[:from])
    to   = ( args[:to].is_a? String )   ? Item.find_by_name(args[:to])   : Item.find(args[:to])
    
    to.loots       += from.loots
    to.wishlists   += from.wishlists
    to.loot_tables += from.loot_tables
    
    Item.update_counters(to.id, :loots_count => from.loots_count, 
      :wishlists_count => from.wishlists_count)
    
    from.delete
    
    return to
  end
  
  # Instance Methods ----------------------------------------------------------
  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end
  
  private
    # Use the real, in-game name at all times
    #
    # Some people are lazy and like to enter item names in all lowercase, or
    # leave their caps lock on, or some shit. This method ensures that, if we
    # have available to us an ItemStat record, we use the name from that.
    def use_proper_name
      return if self.item_stat_id.nil?
      
      item = self.item_stat.item
      self.name = item unless item.nil? or self.name == item
    end
end
