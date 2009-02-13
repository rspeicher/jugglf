# == Schema Information
# Schema version: 20090208213027
#
# Table name: items
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  price        :float           default(0.0)
#  situational  :boolean(1)
#  best_in_slot :boolean(1)
#  member_id    :integer(4)
#  raid_id      :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  rot          :boolean(1)
#

class Item < ActiveRecord::Base
  # Relationships -------------------------------------------------------------
  # NOTE: counter_cache with non-has_many :through assocations and the << operator is FUCKING BUGGY AS SHIT
  # See https://gist.github.com/862e344f8ec10995de66
  belongs_to :member#, :counter_cache => true
  belongs_to :raid#, :counter_cache => true
  alias_method :buyer, :member
  
  # Class Methods -------------------------------------------------------------
  def self.from_attendance_output(line)
    split = line.split(" - ")
    return unless split.length == 2
    
    retval = []
    
    buyer_side = split[0].split(",")
    item_side  = split[1].gsub(/\[(.+)\]/, '\1').strip # Item name, no brackets
    
    buyer_side.each do |buyer|
      item = Item.new
      
      buyer = buyer.strip
      
      # These next regex just mean "contained within parenthesis where the only
      # other values are a-z and \s"; Prevents "Tsitgo" as a name from 
      # matching "sit" as a tell type while still allowing "(bis rot)"
      item.situational  = !buyer.match(/\(([a-z\s]+)?sit([a-z\s]+)?\)/).nil?
      item.best_in_slot = !buyer.match(/\(([a-z\s]+)?bis([a-z\s]+)?\)/).nil?
      item.rot          = !buyer.match(/\(([a-z\s]+)?rot([a-z\s]+)?\)/).nil?
      
      # Item name and buyer
      unless buyer == 'DE'
        member = Member.find_or_initialize_by_name(buyer.gsub(/^([A-Za-z]+).*?$/, '\1'))
        member.uncached_updates += 1
        item.member = member
      end
      
      item.name   = item_side
      
      price = item.determine_item_price()
      if price.is_a? Float
        item.price = price
      else
        # item.price = 99999.00 # FIXME: How do we tell the user that we couldn't determine the price for this item?
        item.price = price[0] # NOTE: Just assuming the higher cost for now
      end
      
      retval.push(item)
    end
    
    retval
  end
  
  # Instance Methods ----------------------------------------------------------
  def affects_loot_factor?
    self.raid.date >= 8.weeks.ago.to_datetime if self.raid
  end
  
  def adjusted_price
    ( self.rot? ) ? 0.50 : self.price
  end
  
  def determine_item_price
    ItemPrice.new.price(ItemStat.lookup_by_name(self.name), buyer_is_hunter?)
  end
  
  private
    def buyer_is_hunter?
      self.buyer and self.buyer.wow_class == 'Hunter'
    end
end

class ItemPrice
  MIN_LEVEL = 199
  
  def initialize
    @values = {
      'Head' => nil, 'Chest' => nil, 'Legs' => {
        '199' => 0.00, '200' => 2.00, '213' => 2.50, '226' => 3.00
      },
      'Shoulder' => nil, 'Shoulders' => nil, 'Hands' => nil, 'Feet' => {
        '199' => 0.00, '200' => 1.50, '213' => 2.00, '226' => 2.50
      },
      'Wrist' => nil, 'Waist' => nil, 'Finger' => {
        '199' => 0.00, '200' => 1.00, '213' => 1.50, '226' => 2.00
      },
      'Neck' => nil, 'Back' => {
        '199' => 0.00, '200' => 1.50, '213' => 2.00, '226' => 2.50
      },
      'Two-Hand' => {
        '199' => [0.00, 0.00], '200' => [4.00, 1.50], '213' => [5.00, 2.00], '226' => [6.00, 2.50]
      },
      'Main Hand' => {
        '199' => [0.00, 0.00], '200' => [3.00, 0.75], '213' => [3.50, 1.00], '226' => [4.00, 1.25]
      },
      'One-Hand' => nil, 'Off Hand' => nil, 'Shield' => nil, 'Held In Off-hand' => {
        '199' => [0.00, 0.00], '200' => [1.00, 0.75], '213' => [1.50, 1.00], '226' => [2.00, 1.25]
      },
      'Relic' => nil, 'Idol' => nil, 'Totem' => nil, 'Thrown' => nil, 'Sigil' => nil, 'Ranged' => {
        '199' => [0.00, 0.00], '200' => [0.50, 3.00], '213' => [1.00, 4.00], '226' => [1.50, 5.00]
      },
      'Trinket' => {
        # Wrath
        'Bandit\'s Insignia'              => 3.50,
        'Defender\'s Code'                => 3.00,
        'Dying Curse'                     => 3.50,
        'Extract of Necromantic Power'    => 2.50,
        'Extract of Necromatic Power'     => 2.50,
        'Forethought Talisman'            => 3.50,
        'Fury of the Five Flights'        => 4.00,
        'Grim Toll'                       => 3.00,
        'Illustration of the Dragon Soul' => 4.00,
        'Living Ice Crystals'             => 2.00,
        'Mark of Norgannon'               => 2.00,
        'Rune of Repulsion'               => 2.00,
        'Soul of the Dead'                => 4.00,
      }
    }
    
    @values['Head'] = @values['Chest'] = @values['Legs']
    @values['Shoulder'] = @values['Shoulders'] = @values['Hands'] = @values['Feet']
    @values['Wrist'] = @values['Waist'] = @values['Finger']
    @values['Neck'] = @values['Back']
    @values['One-Hand'] = @values['Off Hand'] = @values['Shield'] = @values['Held In Off-hand']
    @values['Relic'] = @values['Idol'] = @values['Totem'] = @values['Thrown'] = @values['Sigil'] = @values['Ranged']
  end
  
  def price(stat, is_hunter = nil)
    if not stat.level or stat.level < MIN_LEVEL or not stat.slot
      special_case_stats(stat)
    end
    
    if stat.slot == 'Trinket'
      value = trinket_value(stat)
    elsif stat.slot == 'One-Hand'
      value = onehand_value(stat, is_hunter)
    else
      value = nil
      
      unless @values[stat.slot]
        raise "Invalid item slot: #{stat.slot} for item #{stat.item}"
      else
        @values[stat.slot].sort.each do |level,values|
          if level.to_i <= stat.level
            if values.is_a? Float
              value = values
            else
              value = is_hunter ? values[1] : values[0]
            end
          end # k <= level
        end # each_pair
      end # Hash
    end # else
    
    value
  end
  
  private
    def trinket_value(stat)
      value = nil
      
      if @values['Trinket'][stat.item]
        value = @values['Trinket'][stat.item]
      else
        raise "Invalid Trinket: #{name}"
      end
      
      value
    end
    
    def onehand_value(stat, is_hunter)
      value = nil
      
      slotval = @values[stat.slot]
      slotval.sort.each do |level,values|
        if level.to_i <= stat.level
          # One-Hand weapons have the same price for Hunters regardless of MH/OH
          if is_hunter
            value = values[1]
          else
            value = [ @values['Main Hand'][level][0], values[0] ]
          end
        end
      end
      
      value
    end
    
    # NOTE: There's an argument to be made that this belongs in ItemStats and not here
    # We do store the changes we make, however since these changes only happen
    # to very specific cases and not all Tier tokens, for example, I think for
    # now it makes the most sense to leave them in the class that changes them
    def special_case_stats(stat)
      value = nil
      
      if stat.item == 'Heroic Key to the Focusing Iris'
        stat.slot  = 'Neck'
        stat.level = 226
      elsif stat.level == 80
        # Probably a Tier 7/7.5 token
        matches = stat.item.match(/^(.+) of the Lost (Conqueror|Protector|Vanquisher)$/)
        if matches.length > 0
          case matches[1]
          when 'Breastplate'
            stat.slot  = 'Chest'
            stat.level = 213
          when 'Chestguard'
            stat.slot  = 'Chest'
            stat.level = 200
          when 'Crown'
            stat.slot  = 'Head'
            stat.level = 213
          when 'Helm'
            stat.slot  = 'Head'
            stat.level = 200
          when 'Gauntlets'
            stat.slot  = 'Hands'
            stat.level = 213
          when 'Gloves'
            stat.slot  = 'Hands'
            stat.level = 200
          when 'Legplates'
            stat.slot  = 'Legs'
            stat.level = 213
          when 'Leggings'
            stat.slot  = 'Legs'
            stat.level = 200
          when 'Mantle'
            stat.slot  = 'Shoulders'
            stat.level = 213
          when 'Spaulders'
            stat.slot  = 'Shoulders'
            stat.level = 200
          end
        end
      end
      
      stat.save!
    end
end