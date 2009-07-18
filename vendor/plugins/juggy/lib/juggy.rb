require 'item_price'

module Juggy
  class << self
    def parse_attendees(output)
      return if output.nil? or output.empty?
      
      retval = []
 
      require 'csv'
      lines = CSV.parse(output) do |line|
        next if line[0].nil? or line[0].strip.empty?
        next if line[1].nil? or line[1].strip.empty?
        
        retval << { :name => line[0].strip, :attendance => line[1].to_f }
      end
      
      retval
    end
    
    def parse_loots(output)
      return if output.nil? or output.empty?
    
      retval = []
    
      lines = output.split("\n")
      lines.each do |line|
        split = line.split(' - ')
        next unless split.length == 2
      
        buyers    = split[0].split(',')
        item_name = split[1].gsub(/\[(.+)\]/, '\1').strip # Item name, no brackets
      
        buyers.each do |buyer|
          loot = generate_loot(buyer, item_name)
        
          retval << loot
        end
      end
    
      retval
    end
    
    private
      def generate_loot(buyer, item_name)
        buyer.strip! unless buyer.nil?
        item_name.strip! unless item_name.nil?
        
        return if buyer.nil? or buyer.empty? or item_name.nil? or item_name.empty?
        
        retval = { }
        retval[:item] = Item.find_or_initialize_by_name(item_name)
      
        # These next regex just mean "contained within parenthesis where the only
        # other values are a-z and \s"; Prevents "Tsitgo" as a name from 
        # matching "sit" as a tell type while still allowing "(bis rot)"
        retval[:best_in_slot] = !buyer.match(/\(([a-z\s]+)?bis([a-z\s]+)?\)/).nil?
        retval[:situational]  = !buyer.match(/\(([a-z\s]+)?sit([a-z\s]+)?\)/).nil?
        retval[:rot]          = !buyer.match(/\(([a-z\s]+)?rot([a-z\s]+)?\)/).nil?
      
        # Only set the buyer if it's not disenchanted
        unless buyer == 'DE'
          retval[:member] = Member.find_or_initialize_by_name(buyer.gsub(/^(\w+).*?$/, '\1'))
        end
      
        # Item Pricing
        price = nil
        retval[:item].lookup
        stats = retval[:item]
        unless stats.wow_id.nil? or retval[:member].nil?
          price = ItemPrice.instance.price(:name => stats.name,
            :level => stats.level, :slot => stats.slot, 
            :class => retval[:member].wow_class
          )
        end
        
        if price.is_a? Array
          # Item price returned an array, meaning it's a One-Handed weapon and could have two different prices
          # item.price = 99999.00 # FIXME: How do we tell the user that we couldn't determine the price for this item?
          retval[:price] = nil
        else
          retval[:price] = price
        end

        retval
      end
  end
end