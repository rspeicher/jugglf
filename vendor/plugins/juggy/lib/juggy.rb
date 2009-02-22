require 'item_price'

module Juggy
  class << self
    def parse_items(output)
      return if output.nil? or output.empty?
    
      retval = []
    
      lines = output.split("\n")
      lines.each do |line|
        split = line.split(' - ')
        next unless split.length == 2
      
        buyers    = split[0].split(',')
        item_name = split[1].gsub(/\[(.+)\]/, '\1').strip # Item name, no brackets
      
        buyers.each do |buyer|
          item = generate_item(buyer, item_name)
        
          retval << item
        end
      end
    
      retval
    end
    
    def attendees_from_attendance(output)
      # # TODO: Do we self.attendees.destroy_all during an after_update call?
      # return if @attendance_output.nil? or @attendance_output.empty?
      # 
      # require 'csv'
      # lines = CSV.parse(@attendance_output) do |line|
      #   next if line[0].nil? or line[0].strip.empty? 
      #   next if line[1].nil? or line[1].strip.empty?
      #   
      #   m = Member.find_or_initialize_by_name(line[0].strip)
      #   m.save
      # 
      #   begin
      #     self.attendees.create(:member_id => m.id, :attendance => line[1])
      #   rescue ActiveRecord::StatementInvalid => e
      #     # Probably a duplicate entry error caused by having the same member
      #     # twice or more in the output; find the member by id and then
      #     # see which attendance value is lower and use that
      #     a = self.attendees.find_by_member_id(m.id)
      #     if not a.nil? and line[1].to_f < a.attendance
      #       a.attendance = line[1]
      #       a.save
      #     end # lower attendance
      #   end # rescue
      # end #CSV.parse
    end
    
    private
      def generate_item(buyer, item_name)
        return if buyer.nil? or buyer.empty? or item_name.nil? or item_name.empty?
      
        item = Item.new(:name => item_name)
      
        # These next regex just mean "contained within parenthesis where the only
        # other values are a-z and \s"; Prevents "Tsitgo" as a name from 
        # matching "sit" as a tell type while still allowing "(bis rot)"
        item.best_in_slot = !buyer.match(/\(([a-z\s]+)?bis([a-z\s]+)?\)/).nil?
        item.situational  = !buyer.match(/\(([a-z\s]+)?sit([a-z\s]+)?\)/).nil?
        item.rot          = !buyer.match(/\(([a-z\s]+)?rot([a-z\s]+)?\)/).nil?
      
        # Only set the buyer if it's not disenchanted
        unless buyer == 'DE'
          item.member = Member.find_or_initialize_by_name(buyer.gsub(/^(\w+).*?$/, '\1'))
        end
      
        # Item Pricing
        price = nil
        stats = ItemStat.lookup(item.name)
        unless stats.new_record?
          price = ItemPrice.instance.price(:name => stats.item, 
            :level => stats.level, :slot => stats.slot, 
            :hunter => (item.member.wow_class == 'Hunter')
          )
        end
        
        if price.is_a? Array
          # Item price returned an array, meaning it's a One-Handed weapon and could have two different prices
          # item.price = 99999.00 # FIXME: How do we tell the user that we couldn't determine the price for this item?
          item.price = nil
        else
          item.price = price
        end

        item
      end
  end
end