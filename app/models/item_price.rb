require 'singleton'

class ItemPrice
  include Singleton

  def initialize
    @min_level = 359
    @values = {
      'two-hand' => {
        (359..359) => [5.00, 2.00],
        (372..372) => [6.00, 2.50],
      },

      # Melee DPS/Hunter
      'melee_dps_weapon' => {
        (359..359) => [2.50, 1.00],
        (372..372) => [3.00, 1.25],
      },

      'ranged' => {
        (359..359) => [1.00, 4.00],
        (372..372) => [1.50, 5.00],
      },

      'trinket' => {
        # Nothing yet for Cataclysm
      }
    }

    default_ranges = [359..359, 372..372]
    weapon_ranges  = [359..359, 372..372]

    set_prices(:slot => 'head_chest_legs',     :start =>  2.50, :step => 0.50, :ranges => default_ranges)
    set_prices(:slot => 'shoulder_hands_feet', :start =>  2.00, :step => 0.50, :ranges => default_ranges)
    set_prices(:slot => 'wrist_waist_finger',  :start =>  1.50, :step => 0.50, :ranges => default_ranges)
    set_prices(:slot => 'neck_back',           :start =>  1.50, :step => 0.50, :ranges => default_ranges)
    set_prices(:slot => 'main hand',           :start =>  3.50, :step => 0.50, :ranges => weapon_ranges)
    set_prices(:slot => 'offhand',             :start =>  1.50, :step => 0.50, :ranges => weapon_ranges)
  end

  # Given as much information as possible, attempts to determine the price of an +Item+
  #
  # === Valid Options
  # id::    Items which have non-unique names, slot and level data need to be priced based on their ID (Tier 9 and 10 tokens, specifically)
  # name::  Certain items (such as Tier tokens or Legendary fragments) are below our minimum level but still need to be priced as a special case.
  # slot::  Required for almost every item type, as items are grouped into prices by slot
  # level:: Items below a certain level won't be priced above 0.00 no matter what
  # class:: Required for items which have different prices for Hunters and everyone else
  def price(options = {})
    options.assert_valid_keys(:id, :name, :slot, :level, :class)
    prepare_options(options)

    price = nil

    if options[:level] < @min_level or options[:slot].blank?
      # Check for a special legendary token
      if legendary_item?(options)
        price = legendary_value(options)
      else
        price = 0.00
      end
    elsif trinket_item?(options)
      price = trinket_value(options)
    else
      price = default_value(options)
    end

    price
  end

  private

    # Populates +values+ with item prices
    #
    # If the result of adding <tt>(start + (step * iteration))</tt> is a negative, the value will be
    # converted to 0.00, to support a case of multiple groups having a 0.00 value
    #
    # === Valid Options
    # slot::  Slot, for use as the index
    # start:: Starting value for prices
    # step::  Value to add to the price for each level group
    # ranges:: Array of Range objects representing a level group
    #
    # === Examples
    #   >> set_prices(:slot => 'ranged', :start => 0.50, :step => 1.00, :ranges => [1...5, 5...10, 10...15])
    #   => @values['ranged'] = { (1...5) => 0.50, (5...10) => 1.50, (10...15) => 2.50 }
    #   >> set_prices(:slot => 'ranged', :start => -0.50, :step => 0.50, :ranges => [1...5, 5...10, 10...15])
    #   => @values['ranged'] = { (1...5) => 0.00, (5...10) => 0.00, (10...15) => 0.50 }
    def set_prices(options)
      options.assert_valid_keys(:start, :step, :slot, :ranges)

      values = {}
      options[:ranges].each_with_index do |range, i|
        range_value = options[:start] + (options[:step] * i)
        values[range] = ( range_value < 0.00 ) ? 0.00 : range_value
      end

      @values[options[:slot]] = values
    end

    # Prepares and normalizes options passed into +price+
    #
    # If given certain token items, such as "Breastplate of the Forgotten Vanquisher",
    # the appropriate +slot+ and +level+ values will be substituted in.
    def prepare_options(options)
      options[:id]     ||= nil
      options[:name]   ||= nil
      options[:slot]   ||= nil
      options[:level]  ||= 0
      options[:class]  ||= nil

      options[:level] = options[:level].to_i if options[:level].respond_to? 'to_i'

      if options[:level] == 85
        # Tier 11 359 or 372 token
        if options[:name] =~ /^(.+) of the Forlorn (.+)$/
          options[:slot], options[:level] = determine_token_slot_and_level(options[:name])
        end
      end

      special_weapon_options(options) if special_weapon_slot?(options[:slot])
      options[:slot] = normalize_slot(options[:slot])

      options
    end

    # Turns a WoW-style slot value into one usable by ItemPrice
    #
    # === Examples
    #   >> normalize_slot('Neck')
    #   => 'neck'
    #   >> normalize_slot('Relic')
    #   => 'ranged'
    #   >> normalize_slot('Shoulders')
    #   => 'shoulder_hands_feet'
    def normalize_slot(slot)
      return if slot.blank?

      slot = slot.downcase

      # Weird edge case that shouldn't exist anymore
      slot = 'shoulder' if slot == 'shoulders'

      case slot
      when 'head', 'chest', 'legs'
        'head_chest_legs'
      when 'shoulder', 'hands', 'feet'
        'shoulder_hands_feet'
      when 'wrist', 'waist', 'finger'
        'wrist_waist_finger'
      when 'neck', 'back'
        'neck_back'
      when 'shield', 'held in off-hand'
        'offhand'
      when 'one-hand', 'off hand'
        'melee_dps_weapon'
      when 'relic', 'idol', 'totem', 'thrown', 'sigil', 'ranged'
        'ranged'
      else
        slot
      end
    end

    # Simply loops through a hash of values for the given +slot+ and returns the value according to
    # nearest +level+
    def default_value(options)
      # Return early if the values for the given slot don't exist
      return nil if @values[options[:slot]].nil?

      value = 0.00
      slotval = @values[options[:slot]]

      slotval.each_pair do |range, values|
        if range.include? options[:level]
          if values.is_a? Array
            # It's an array, meaning the first value is for non-Hunters, and the second value is for Hunters
            value = (options[:class] == 'Hunter') ? values[1] : values[0]
          else
            value = values
          end
        end
      end

      value
    end

    # Determines if the provided arguments match a Legendary item
    def legendary_item?(options)
      false
    end

    # Returns the price value for legendary tokens that don't have traditional
    # level or slot stats
    def legendary_value(options)
      0.00
    end

    # Determines if the given +slot+ is considered "special" by our pricing system
    #
    # "Special" slots are any of the non-Range, non-Relic weapon slots, and are
    # considered special because they are priced differently depending on the buyer's
    # class.
    def special_weapon_slot?(slot)
      ['Two-Hand', 'Main Hand', 'Held In Off-hand', 'One-Hand', 'Off Hand', 'Shield'].include? slot
    end

    # Modifies +options+ based on special weapon conditions
    #
    # For example, a Main Hand and an Off Hand weapon are the same prices for a Rogue
    def special_weapon_options(options)
      return if options[:class].nil?

      if options[:class] == 'Warrior'
        # Warriors treat everything as a one-hand DPS weapon, since they can dual-wield Two-Handers
        options[:slot] = 'melee_dps_weapon'
      elsif ['Death Knight', 'Hunter', 'Rogue'].include? options[:class]
        # Price these special slots as a melee weapon for these classes, except Two-Handers
        options[:slot] = 'melee_dps_weapon' unless options[:slot] == 'Two-Hand'
      elsif options[:class] == 'Shaman'
        # We're gonna guess that a non-Enhancement Shaman would never use a One-Hand weapon
        options[:slot] = 'melee_dps_weapon' if options[:slot] == 'One-Hand'
      end
    end

    # Determines if the provided arguments match a Trinket item
    def trinket_item?(options)
      options[:slot] == 'trinket'
    end

    def trinket_value(options)
      4.00
      # value = nil

      # if @values['trinket'][options[:name]]
      #   value = @values['trinket'][options[:name]]

      #   # 3.2 Trinkets share names with their lower-level counterparts
      #   if value.is_a? Array
      #     value = ( options[:level] == 245 or options[:level] == 264 ) ? value[0] : value[1]
      #   end
      # else
      #   # raise "Invalid Trinket: #{options[:name]}"
      # end

      # value
    end

    # Given a token name, determines the WoW slot name and actual level
    #
    # Examples:
    #   >> determine_token_slot_and_level('Shoulders of the Forlorn Conqueror')
    #   => ['Shoulder', 372]
    #   >> determine_token_slot_and_level('Helm of the Forlorn Conqueror')
    #   => ['Head', 359]
    def determine_token_slot_and_level(name)
      slot = name.split.shift.downcase

      case slot
      when 'chest'
        ['Chest', 372]
      when 'crown'
        ['Head', 372]
      when 'gauntlets'
        ['Hands', 372]
      when 'helm'
        ['Head', 359]
      when 'leggings'
        ['Legs', 372]
      when 'mantle'
        ['Shoulder', 359]
      when 'shoulders'
        ['Shoulder', 372]
      end
    end
end
