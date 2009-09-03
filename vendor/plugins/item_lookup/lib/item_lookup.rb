module ItemLookup
  require 'cgi'
  require 'open-uri'
  require 'nokogiri'
  
  class << self
    def search(query, options = {})
      options[:source] ||= 'armory'
      
      case options[:source]
      when 'armory'
        Armory.search(query, options)
      when 'wowhead'
        Wowhead.search(query, options)
      end
    end
  end
  
  # An array of Result objects
  class Results < Array
    # Return the best result, where 'best' is the highest item level
    def best_result
      return Result.new unless self.length > 0
      
      self.sort { |x,y| y.level <=> x.level }[0]
    end
  end
  
  # A single item result with the properties we care about
  class Result
    attr_accessor :id
    attr_accessor :name
    attr_accessor :quality
    attr_accessor :icon
    attr_accessor :level
    
    # TODO: Store all slots in the DB as an integer, and translate them to a string as necessary
    # Requires some heavy migrating
    SLOT_MAP = {
      0  => nil,
      1  => 'Head',
      2  => 'Neck',
      3  => 'Shoulder',
      # 4  => '',
      5  => 'Chest',
      6  => 'Waist',
      7  => 'Legs',
      8  => 'Feet',
      9  => 'Wrist',
      10 => 'Hands',
      11 => 'Finger',
      12 => 'Trinket',
      13 => 'One-Hand',
      14 => 'Shield',
      # 15 => '',
      16 => 'Back',
      17 => 'Two-Hand',
      18 => 'Bag',
      # 19 => '',
      # 20 => '',
      21 => 'Main Hand',
      22 => 'Off Hand',
      23 => 'Held In Off-hand',
      # 24 => '',
      25 => 'Thrown',
      26 => 'Ranged',
      # 27 => '',
      28 => 'Relic'
    }
    
    def valid?
      @id.present? and @id > 0 and !(@name.empty?) and @quality > -1 and !(@icon.empty?) and @level > -1
    end
    
    def slot
      @slot_name
    end
    def slot=(value)
      if value.is_a? Fixnum
        @slot_name = SLOT_MAP[value] or nil
      else
        @slot_name = value
      end
    end
    
    def css_quality
      'q' + quality.to_s
    end
  end
  
  private
    class Armory
      def self.search(query, options = {})
        # Process is different for an item name and an item ID
        if query =~ /^\d+$/ or query.is_a? Fixnum
          query = query.to_i if query.respond_to? 'to_i'
          self.search_id(query, options)
        else
          query = query.to_s if query.respond_to? 'to_s'
          query = query.strip.downcase
          self.search_name(query, options)
        end
      end
      
      private
        # HTTP headers used to make wowarmory.com give us what we want!
        def self.content_headers
          { 'User-Agent'      => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.0.7) Gecko/2009021906 Firefox/3.0.7",
            'Accept-language' => 'enUS' }
        end
        
        def self.search_id(query, options = {})
          results        = Results.new
          
          doc = Nokogiri::XML(open("http://www.wowarmory.com/item-tooltip.xml?i=#{query}", content_headers))
          item = doc.search('page/itemTooltips/itemTooltip').first
          unless item.nil?
            result         = Result.new
            result.id      = item.search('id').first.content.to_i
            result.name    = item.search('name').first.content
            result.quality = item.search('overallQualityId').first.content.to_i
            result.icon    = item.search('icon').first.content
            result.slot    = item.search('equipData/inventoryType').first.content.to_i
            
            # Wowarmory tooltip pages don't include the item level, and item info pages don't include the slot. That's gonna cost them an extra hit.
            info = Nokogiri::XML(open("http://www.wowarmory.com/item-info.xml?i=#{result.id}", content_headers))
            result.level = info.search('page/itemInfo/item').first['level'].to_i
            
            results << result
          end
          
          results
        end
        
        def self.search_name(query, options = {})
          results = Results.new

          doc = Nokogiri::XML(open("http://www.wowarmory.com/search.xml?searchQuery=#{CGI.escape(query)}&searchType=items", content_headers))
          unless doc.search('page/armorySearch/searchResults/items/item').first.nil?
            doc.search('page/armorySearch/searchResults/items/item').each do |item|
              if item['name'].strip.downcase == query
                result         = Result.new
                result.id      = item['id'].to_i
                result.name    = item['name']
                result.quality = item['rarity'].to_i
                result.icon    = item['icon']
                result.level   = item.search('filter[@name="itemLevel"]').first['value'].to_i
                
                # Search results don't include the item slot. That's gonna cost them an extra hit.
                tooltip = Nokogiri::XML(open("http://www.wowarmory.com/item-tooltip.xml?i=#{result.id}", content_headers))
                result.slot = tooltip.search('page/itemTooltips/itemTooltip/equipData/inventoryType').first.content.to_i
                
                results << result
              end
            end
          end
          
          results
        end
    end
    
    class Wowhead
      def self.search(query, options = {})
        results = Results.new
        
        query = query.to_s if query.respond_to? 'to_s'
        query = query.strip.downcase

        doc = Nokogiri::XML(open("http://www.wowhead.com/?item=#{CGI.escape(query)}&xml"))
        if doc.search('wowhead/error').first.nil?
          results = Results.new
          
          wowhead_id   = doc.search('wowhead/item').first['id']
          wowhead_item = doc.search('wowhead/item/name').first.content

          if wowhead_id.to_i == query.to_i or wowhead_item.downcase == query
            result         = Result.new
            result.id      = wowhead_id.to_i
            result.name    = wowhead_item
            result.quality = doc.search('wowhead/item/quality').first['id'].to_i
            result.icon    = doc.search('wowhead/item/icon').first.content
            result.level   = doc.search('wowhead/item/level').first.content.to_i
            result.slot    = doc.search('wowhead/item/inventorySlot').first['id'].to_i
            
            results << result
          end
        end
      end
    end
end