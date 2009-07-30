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
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :wow_id
  
  # Callbacks -----------------------------------------------------------------
  before_validation_on_create :convert_item_id_to_name
  
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
  def wowhead_link
    "http://www.wowhead.com/?item=#{self.wow_id}"
  end
  def wowhead_icon(size = 'small')
    "http://static.wowhead.com/images/icons/#{size.downcase}/#{self.icon.downcase}.jpg"
  end
  
  def lookup(force_refresh = false)
    if self.wow_id.nil? or force_refresh
      wowhead_lookup(self.name)
      
      if self.valid?
        self.save
      end
    end
  end
  
  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end
  
  private
    # Allow a user to enter an item ID in the name field to have the Item record
    # automatically look up the record from Wowhead
    def convert_item_id_to_name
      return unless self.name =~ /^\d+$/
      
      wowhead_lookup(self.name)
    end
    
    def wowhead_lookup(query)
      require 'cgi'
      require 'open-uri'
      require 'nokogiri'
    
      query = query.to_s if query.respond_to? 'to_s'
      query = query.strip.downcase
    
      url = "http://www.wowhead.com/?item=#{CGI.escape(query)}&xml"
    
      logger.debug "Hitting Wowhead (#{url})"
      doc = Nokogiri::XML(open(url))
      if doc.search('wowhead/error').first.nil?
        wowhead_id   = doc.search('wowhead/item').first['id']
        wowhead_item = doc.search('wowhead/item/name').first.content
        
        if wowhead_id.to_i == query.to_i or wowhead_item.downcase == query
          self.name    = wowhead_item
          self.wow_id  = wowhead_id
          self.color   = "q#{doc.search('wowhead/item/quality').first['id']}"
          self.icon    = doc.search('wowhead/item/icon').first.content
          self.level   = doc.search('wowhead/item/level').first.content
          self.slot    = doc.search('wowhead/item/inventorySlot').first.content { |e| stat.slot = e.text }
        end
      end
    end
end
