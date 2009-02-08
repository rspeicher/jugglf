# == Schema Information
# Schema version: 20090208213027
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
  # Class Methods -------------------------------------------------------------
  def self.lookup_by_item_id(id)
    stat = ItemStat.find_or_initialize_by_item_id(id)
    
    if stat.new_record?
      self.wowhead_lookup(id, stat)
    end
    
    stat
  end
  def self.lookup_by_name(name)
    stat = ItemStat.find_or_initialize_by_item(name)
    
    if stat.new_record?
      self.wowhead_lookup(name, stat)
    end
    
    stat
  end
  
  # Instance Methods ----------------------------------------------------------
  def wowhead_icon(size = 'small')
    "http://static.wowhead.com/images/icons/#{size.downcase}/#{self.icon.downcase}.jpg"
  end
  
  private
    def self.wowhead_lookup(item, stat)
      require 'net/http'
      require 'rexml/document'
      require 'cgi'
      
      xml_data = Net::HTTP.get_response(URI.parse("http://www.wowhead.com/?item=#{CGI.escape(item.to_s)}&xml")).body
      doc = REXML::Document.new(xml_data)
      doc.elements.each('wowhead/item') { |e| stat.item_id = e.attribute('id').to_s }
      doc.elements.each('wowhead/item/name') { |e| stat.item = e.text }
      doc.elements.each('wowhead/item/level') { |e| stat.level = e.text }
      doc.elements.each('wowhead/item/quality') { |e| stat.color = "q#{e.attribute('id')}" }
      doc.elements.each('wowhead/item/icon') { |e| stat.icon = e.text }
      doc.elements.each('wowhead/item/inventorySlot') { |e| stat.slot = e.text }
      
      stat.save!
      
      stat
    end
end
