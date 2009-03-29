# == Schema Information
# Schema version: 20090312150316
#
# Table name: item_stats
#
#  id         :integer(4)      not null, primary key
#  wow_id     :integer(4)
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
  validates_presence_of :wow_id
  validates_presence_of :item
  
  # Callbacks -----------------------------------------------------------------
  
  # Class Methods -------------------------------------------------------------
  def self.lookup(query, refresh = false)
    if query.is_a?(Integer) or query.to_s.match(/^\d+$/)
      self.lookup_by_id(query.to_i, refresh)
    else
      self.lookup_by_name(query, refresh)
    end
  end
  
  def self.lookup_by_id(id, refresh = false)
    stat = ItemStat.find_or_initialize_by_wow_id(id)
    
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
    "http://ptr.wowhead.com/?item=#{self.wow_id}"
  end
  def wowhead_icon(size = 'small')
    "http://static.wowhead.com/images/icons/#{size.downcase}/#{self.icon.downcase}.jpg"
  end
  
  private
    def self.wowhead_lookup(item, stat)
      require 'cgi'
      require 'open-uri'
      require 'nokogiri'
      
      item = item.strip.downcase if item.is_a? String
      
      url = "http://ptr.wowhead.com/?item=#{CGI.escape(item.to_s)}&xml"
      
      logger.debug "Hitting Wowhead (#{url})"
      doc = Nokogiri::XML(open(url))
      if doc.search('wowhead/error').first.nil?
        wowhead_id   = doc.search('wowhead/item').first['id']
        wowhead_item = doc.search('wowhead/item/name').first.content
        
        if wowhead_id.to_i == item.to_i or wowhead_item.downcase == item
          stat.wow_id  = wowhead_id
          stat.item    = wowhead_item
          stat.level   = doc.search('wowhead/item/level').first.content
          stat.color   = "q#{doc.search('wowhead/item/quality').first['id']}"
          stat.icon    = doc.search('wowhead/item/icon').first.content
          stat.slot    = doc.search('wowhead/item/inventorySlot').first.content { |e| stat.slot = e.text }
      
          if stat.valid?
            stat.save!
          
            return stat
          end
        end
      end

      # Something went wrong above, create an item record so we don't continue
      # hitting Wowhead's servers with a bogus query.
      stat.wow_id  = nil
      stat.item    = item
      stat.level   = nil
      stat.color   = nil
      stat.icon    = 'INV_Misc_QuestionMark'
      stat.slot    = nil
      
      stat.save(false)
      return stat
    end
end
