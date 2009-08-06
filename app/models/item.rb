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
  attr_accessible :name, :wow_id, :color, :icon, :level, :slot
  
  searchify :name
  
  # Validations ---------------------------------------------------------------
  # Check that name exists, but only if we don't have a wow_id, since we allow
  # lookup by name OR wow_id
  validates_presence_of :name, :if => Proc.new { |item| item.wow_id.nil? }
  validates_uniqueness_of :name, :scope => :wow_id
  
  # Callbacks -----------------------------------------------------------------
  before_save :get_name_from_wow_id
  
  # Class Methods -------------------------------------------------------------
  # Allows the user to pass either an integer to FoC by wow_id, or a string to FoC by name
  def self.find_or_create_by_name_or_wow_id(value)
    if value =~ /^\d+$/ or value.is_a? Fixnum
      self.find_or_create_by_wow_id(value)
    else
      self.find_or_create_by_name(value)
    end
  end
  
  def self.find_by_name_or_wow_id(value)
    if value =~ /^\d+$/ or value.is_a? Fixnum
      self.find_by_wow_id(value)
    else
      self.find_by_name(value)
    end
  end
  
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
  def wowhead_link
    "http://www.wowhead.com/?item=#{self.wow_id}"
  end
  def wowhead_icon(size = 'small')
    size = size.to_s if size.respond_to? 'to_s'
    "http://static.wowhead.com/images/icons/#{size.downcase}/#{self.icon.downcase}.jpg"
  end
  
  # NOTE: Can only lookup by name
  def lookup(force_refresh = false)
    if self.wow_id.nil? or force_refresh
      stat_lookup(self.name)
      
      if self.valid?
        self.save
      end
    end
  end
  
  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end
  
  protected
    def get_name_from_wow_id
      if self.wow_id.nil? == false and self.name.nil? == true
        # Record was probably created with nothing but a wow_id; perform a lookup
        stat_lookup(self.wow_id)
      end
    end
    
    def stat_lookup(query)
      result = ItemLookup.search(query, :source => 'armory').best_result
      if result.valid?
        self.wow_id = result.id
        self.name   = result.name
        self.color  = result.css_quality
        self.icon   = result.icon
        self.level  = result.level
        self.slot   = result.slot
      end
    end
end
