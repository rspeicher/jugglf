# = AttendanceParser
#
# This class acts as a medium between the output from +LiveRaid+, and the input
# pasted in from the forums in <tt>Raids#new</tt>.
#
# Ideally this class should be removed entirely. The LiveRaid should post to
# the forums as normal, but it should then just create the raid and add the
# loot at the same time. This hasn't been done yet because we haven't yet
# created a satisfying way of fixing mistakes between the attendance and the
# actual raid, and editing text on a forum currently works well for that.
#
# Consider this a giant FIXME!
class AttendanceParser
  def self.parse_attendees(output)
    return unless output.present?

    retval = []

    require 'csv'
    lines = CSV.parse(output) do |line|
      next if line[0].nil? or line[0].strip.empty?
      next if line[1].nil? or line[1].strip.empty?

      retval << { :name => line[0].strip, :attendance => line[1].to_f }
    end

    retval
  end

  def self.parse_loots(output)
    return if output.nil? or output.empty?

    retval = []

    lines = output.split("\n")
    lines.each do |line|
      split = line.split(' - ')
      next unless split.length == 2

      buyers    = split[0].split(',')
      item_name = split[1].gsub(/\[(.+)\]/, '\1').strip # Item name, no brackets

      buyers.each do |buyer|
        loot = parse_loot_line(buyer, item_name)

        retval << loot
      end
    end

    retval
  end

  private
    def self.parse_loot_line(buyer, item_name)
      return unless buyer.present? and item_name.present?
      buyer.strip!
      item_name.strip!

      retval = { :item   => nil, :member => nil }

      # Now an Item ID might be included in the form "Name|ID", so see if we got one
      item_name, item_id = item_name.split('|')

      # Fetch an item record based on its name or ID
      if item_id.nil?
        retval[:item] = Item.find_or_initialize_by_name(item_name)
      else
        retval[:item] = Item.find_or_initialize_by_id(item_id)
      end

      # Set BiS/Rot/Sit
      set_loot_types(retval, buyer)

      # Only set the buyer if it's not disenchanted
      unless buyer == 'DE'
        retval[:member] = Member.find_or_initialize_by_name(buyer.gsub(/^(\w+).*?$/, '\1'))
      end

      # Item Pricing
      retval[:price] = price(retval[:item], retval[:member])

      retval
    end

    def self.set_loot_types(loot, buyer)
      # These next regex just mean "contained within parenthesis where the only
      # other values are a-z and \s"; Prevents "Tsitgo" as a name from
      # matching "sit" as a tell type while still allowing "(bis rot)"
      loot[:best_in_slot] = !buyer.match(/\(([a-z\s]+)?bis([a-z\s]+)?\)/).nil?
      loot[:situational]  = !buyer.match(/\(([a-z\s]+)?sit([a-z\s]+)?\)/).nil?
      loot[:rot]          = !buyer.match(/\(([a-z\s]+)?rot([a-z\s]+)?\)/).nil?
    end

    # Given an initialized Item object
    def self.price(item, member = nil)
      return if member.nil?

      price = nil

      item.lookup # Get the data we need if we haven't already
      unless item.id.nil?
        price = ItemPrice.instance.price(:name => item.name,
          :level => item.level, :slot => item.slot,
          :class => member.wow_class, :id => item.id)
      end

      price
    end
end
