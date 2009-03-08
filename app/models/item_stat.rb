# == Schema Information
# Schema version: 20090225185730
#
# Table name: item_stats
#
#  id         :integer(4)      not null, primary key
#  item_id    :integer(4)
#  item       :string(255)
#  locale     :string(10)      default("en")
#  color      :string(15)
#  icon       :string(255)
#  level      :integer(8)      default(0)
#  slot       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ItemStat < ActiveRecord::Base
  # Relationships -------------------------------------------------------------
  has_many :items, :dependent => :nullify
  
  # Attributes ----------------------------------------------------------------
  
  # Validations ---------------------------------------------------------------
  validates_presence_of :item_id
  validates_presence_of :item
  
  # Callbacks -----------------------------------------------------------------
  
  # Class Methods -------------------------------------------------------------
  def self.lookup(query, refresh = false)
    if query.is_a? String
      self.lookup_by_name(query, refresh)
    else
      self.lookup_by_id(query.to_i, refresh)
    end
  end
  
  def self.lookup_by_id(id, refresh = false)
    stat = ItemStat.find_or_initialize_by_item_id(id)
    
    if stat.new_record? or refresh
      self.wowhead_lookup(id, stat)
    end
    
    stat
  end
  def self.lookup_by_name(name, refresh = false)
    stat = ItemStat.find_or_initialize_by_item(name)
    
    if stat.new_record? or refresh
      self.wowhead_lookup(name, stat)
    end
    
    stat
  end
  
  # Instance Methods ----------------------------------------------------------
  def wowhead_link
    "http://www.wowhead.com/?item=#{self.item_id}"
  end
  def wowhead_icon(size = 'small')
    "http://static.wowhead.com/images/icons/#{size.downcase}/#{self.icon.downcase}.jpg"
  end
  
  private
    def self.wowhead_lookup(item, stat)
      require 'cgi'
      require 'open-uri'
      require 'nokogiri'
      
      doc = Nokogiri::XML(open("http://www.wowhead.com/?item=#{CGI.escape(item.to_s)}&xml"))
      if doc.search('wowhead/error').first.nil?
        stat.item_id = doc.search('wowhead/item').first['id']
        stat.item    = doc.search('wowhead/item/name').first.content
        stat.level   = doc.search('wowhead/item/level').first.content
        stat.color   = "q#{doc.search('wowhead/item/quality').first['id']}"
        stat.icon    = doc.search('wowhead/item/icon').first.content
        stat.slot    = doc.search('wowhead/item/inventorySlot').first.content { |e| stat.slot = e.text }
      
        if stat.valid?
          stat.save!
        end
      end
      
      stat
    end
end
