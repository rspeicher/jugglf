require 'singleton'

class ItemPrice
  include Singleton

  def initialize
    @min_level = 226
    @values = {
      'two-hand' => {
        (226...232) => [0.00, 0.00],
        (232...239) => [1.00, 0.00],
        (239...245) => [2.00, 0.50],
        (245...258) => [3.00, 1.00],
        (258...264) => [4.00, 1.50],
        (264...277) => [5.00, 2.00],
        (277...284) => [6.00, 2.50],
        (284...300) => [7.00, 3.00]
      },

      # Melee DPS/Hunter
      'melee_dps_weapon' => {
        (226...232) => [0.00, 0.00],
        (232...239) => [0.50, 0.00],
        (239...245) => [1.00, 0.00],
        (245...258) => [1.50, 0.50],
        (258...264) => [2.00, 0.75],
        (264...277) => [2.50, 1.00],
        (277...284) => [3.00, 1.25],
        (284...300) => [3.50, 1.50]
      },

      'ranged' => {
        (226...232) => [0.00, 0.00],
        (232...239) => [0.00, 0.00],
        (239...245) => [0.00, 1.00],
        (245...258) => [0.00, 2.00],
        (258...264) => [0.50, 3.00],
        (264...277) => [1.00, 4.00],
        (277...284) => [1.50, 5.00],
        (284...300) => [2.00, 6.00]
      },

      'trinket' => {
        # Patch 3.1
        "Blood of the Old God"              => 0.00,
        "Comet's Trail"                     => 1.00,
        "Flare of the Heavens"              => 1.00,
        "Heart of Iron"                     => 0.00,
        "Living Flame"                      => 0.00,
        "Pandora's Plea"                    => 0.00,
        "Scale of Fates"                    => 0.00,
        "Show of Faith"                     => 1.00,
        "The General's Heart"               => 0.00,
        "Vanquished Clutches of Yogg-Saron" => 0.00,
        "Wrathstone"                        => 0.00,

        # Patch 3.2 [245 price, 258 price]
        "Death's Choice"        => [2.00, 4.00],
        "Juggernaut's Vitality" => [2.00, 4.00],
        "Reign of the Dead"     => [2.00, 4.00],
        "Solace of the Fallen"  => [2.00, 4.00],

        # Patch 3.3 [264 price, 277 price]
        "Althor's Abacus"                 => [2.00, 4.00],
        "Bauble of True Blood"            => [2.00, 4.00],
        "Corpse Tongue Coin"              => [2.00, 4.00],
        "Deathbringer's Will"             => [2.00, 4.00],
        "Dislodged Foreign Object"        => [2.00, 4.00],
        "Phylactery of the Nameless Lich" => [2.00, 4.00],
        "Sindragosa's Flawless Fang"      => [2.00, 4.00],
        "Tiny Abomination in a Jar"       => [2.00, 4.00],

        # Patch 3.3.5 [277 price, 284 price]
        'Charred Twilight Scale'   => [2.00, 4.00],
        'Glowing Twilight Scale'   => [2.00, 4.00],
        'Petrified Twilight Scale' => [2.00, 4.00],
        'Sharpened Twilight Scale' => [2.00, 4.00],
      }
    }

    default_ranges = [226...239, 239...245, 245...258, 258...264, 264...277, 277...284, 284...300]
    weapon_ranges  = [226...232, 232...239, 239...245, 245...258, 258...264, 264...277, 277...284, 284...300]

    set_prices(:slot => 'head_chest_legs',     :start =>  0.50, :step => 0.50, :ranges => default_ranges)
    set_prices(:slot => 'shoulder_hands_feet', :start =>  0.00, :step => 0.50, :ranges => default_ranges)
    set_prices(:slot => 'wrist_waist_finger',  :start => -0.50, :step => 0.50, :ranges => default_ranges)
    set_prices(:slot => 'neck',                :start => -0.50, :step => 0.50, :ranges => default_ranges)
    set_prices(:slot => 'back',                :start =>  0.50, :step => 2.50, :ranges => [245...284, 284...300])
    set_prices(:slot => 'main hand',           :start =>  1.00, :step => 0.50, :ranges => weapon_ranges)
    set_prices(:slot => 'shield',              :start => -1.00, :step => 0.50, :ranges => weapon_ranges)
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

      if options[:name] == 'Heroic Key to the Focusing Iris'
        options[:slot]  = 'Neck'
        options[:level] = 226

      elsif options[:name] == 'Reply-Code Alpha'
        # This stupid item can actually be a Ring or a Cloak. Price it as a Ring by default
        options[:slot]  = 'Finger'
        options[:level] = 239

      elsif options[:level] == 80
        if options[:name] =~ /^Regalia of the Grand (Conqueror|Protector|Vanquisher)$/
          # Tier 9 258 Token
          options[:slot] = 'Chest' # Not always, but it has the correct price point we want for all Regalia
          options[:level] = 258

        elsif options[:name] == 'Trophy of the Crusade'
          # Tier 9 245 Token
          options[:slot] = 'Chest' # Not always, but it has the correct price point we want for all Trophies
          options[:level] = 245

        elsif [52025, 52026, 52027].include? options[:id]
          # Tier 10 266 Token
          options[:slot] = 'Chest' # Not always, but it has the correct price point we want for all Marks
          options[:level] = 266

        elsif [52028, 52029, 52030].include? options[:id]
          # Tier 10 277 Token
          options[:slot] = 'Chest' # Not always, but it has the correct price point we want for all Heroic Marks
          options[:level] = 277

        elsif options[:name] =~ /^(.+) of the (Lost|Wayward) (Conqueror|Protector|Vanquisher)$/
          # Tier 8 or Tier 7 token
          options[:slot]  = determine_token_slot($1)
          options[:level] = determine_token_level($1, $2)
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
      when 'shield', 'held in off-hand'
        'shield'
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
      options[:name] == "Fragment of Val'anyr" or options[:name] == "Shadowfrost Shard"
    end

    # Returns the price value for legendary tokens that don't have traditional
    # level or slot stats
    def legendary_value(options)
      if options[:name] == "Fragment of Val'anyr"
        0.00
      elsif options[:name] == "Shadowfrost Shard"
        (10.00 / 50)
      end
    end

    # Determines if the given +slot+ is considered "special" by our pricing system
    #
    # "Special" slots are any of the non-Range, non-Relic weapon slots, and are
    # considered special because they are priced differently depending on the buyer's
    # class.
    def special_weapon_slot?(slot)
      ['Main Hand', 'Held In Off-hand', 'One-Hand', 'Off Hand', 'Shield'].include? slot
    end

    # Modifies +options+ based on special weapon conditions
    #
    # For example, a Main Hand and an Off Hand weapon are the same prices for a Rogue
    def special_weapon_options(options)
      return if options[:class].nil?

      if ['Death Knight', 'Hunter', 'Rogue', 'Warrior'].include? options[:class]
        # Price these special slots as a melee weapon for these classes
        options[:slot] = 'melee_dps_weapon'
      elsif options[:class] == 'Shaman'
        if options[:slot] == 'One-Hand'
          # We're gonna guess that a non-Enhancement Shaman would never use a One-Hand weapon
          options[:slot] = 'melee_dps_weapon'
        end
      end
    end

    # Determines if the provided arguments match a Trinket item
    def trinket_item?(options)
      options[:slot] == 'trinket'
    end

    def trinket_value(options)
      value = nil

      if @values['trinket'][options[:name]]
        value = @values['trinket'][options[:name]]

        # 3.2 Trinkets share names with their lower-level counterparts
        if value.is_a? Array
          value = ( options[:level] == 245 or options[:level] == 264 ) ? value[0] : value[1]
        end
      else
        # raise "Invalid Trinket: #{options[:name]}"
      end

      value
    end

    # Based on a flowery item name, determines the "raw" slot name
    #
    # Supposedly these types of item names will no longer be used,
    # in favor of a single Tier token that can be turned in to receieve
    # any chosen slot.
    #
    # Examples:
    #   >> determine_token_slot("Breastplate")
    #   => 'Chest'
    #   >> determine_token_slot("Spaulders")
    #   => 'Shoulder'
    def determine_token_slot(name)
      name = name.strip.downcase

      if name == 'breastplate' or name == 'chestguard'
        return 'Chest'
      elsif name == 'crown' or name == 'helm'
        return 'Head'
      elsif name == 'gauntlets' or name == 'gloves'
        return 'Hands'
      elsif name == 'legplates' or name == 'leggings'
        return 'Legs'
      elsif name == 'mantle' or name == 'spaulders'
        return 'Shoulder'
      end
    end

    def determine_token_level(piece, group)
      piece = piece.strip.downcase
      group = group.strip.downcase

      if ['chestguard', 'helm', 'gloves', 'leggings', 'spaulders'].include? piece
        # 10-man
        return ( group == 'lost' ) ? 200 : 219
      else
        # 25-man
        return ( group == 'lost' ) ? 213 : 226
      end
    end
end
