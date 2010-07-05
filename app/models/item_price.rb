require 'singleton'

class ItemPrice
  include Singleton

  def initialize
    @min_level = 226
    @values = {
      'LEVELS' => ['226', '239', '245', '258', '264', '277', '284'], # NOTE: Not 272, this array is only used for weapons.

      'Head' => nil, 'Chest' => nil, 'Legs' => {
        '226' => 0.50,
        '239' => 1.00,
        '245' => 1.50,
        '258' => 2.00,
        '264' => 2.50,
        '277' => 3.00,
        '284' => 3.50
      },
      'Shoulder' => nil, 'Shoulders' => nil, 'Hands' => nil, 'Feet' => {
        '226' => 0.00,
        '239' => 0.50,
        '245' => 1.00,
        '258' => 1.50,
        '264' => 2.00,
        '277' => 2.50,
        '284' => 3.00
      },
      'Wrist' => nil, 'Waist' => nil, 'Finger' => {
        '226' => 0.00,
        '239' => 0.00,
        '245' => 0.50,
        '258' => 1.00,
        '264' => 1.50,
        '277' => 2.00,
        '284' => 2.50
      },
      'Neck' => {
        '226' => 0.00,
        '239' => 0.00,
        '245' => 0.50,
        '258' => 1.00,
        '264' => 1.50,
        '277' => 2.50,
        '284' => 3.00
      },
      'Back' => {
        '226' => 0.00,
        '239' => 0.00,
        '245' => 0.50,
        '258' => 0.50,
        '264' => 0.50,
        '272' => 0.50, # Special case for Tribute Chest, grumble.
        '277' => 0.50,
        '284' => 3.00
      },
      'Two-Hand' => {
        '226' => [0.00, 0.00],
        '232' => [1.00, 0.00],
        '239' => [2.00, 0.50],
        '245' => [3.00, 1.00],
        '258' => [4.00, 1.50],
        '264' => [5.00, 2.00],
        '277' => [6.00, 2.50],
        '284' => [7.00, 3.00]
      },

      # Healer/Caster
      'Main Hand' => {
        '226' => 1.00,
        '232' => 1.50,
        '239' => 2.00,
        '245' => 2.50,
        '258' => 3.00,
        '264' => 3.50,
        '277' => 4.00,
        '284' => 4.50
      },
      'Shield' => nil, 'Held In Off-hand' => {
        '226' => 0.00,
        '232' => 0.00,
        '239' => 0.00,
        '245' => 0.50,
        '258' => 1.00,
        '264' => 1.50,
        '277' => 2.00,
        '284' => 2.50
      },
      # Melee DPS/Hunter
      'One-Hand' => nil, 'Off Hand' => nil, 'Melee DPS Weapon' => {
        '226' => [0.00, 0.00],
        '232' => [0.50, 0.00],
        '239' => [1.00, 0.00],
        '245' => [1.50, 0.50],
        '258' => [2.00, 0.75],
        '264' => [2.50, 1.00],
        '277' => [3.00, 1.25],
        '284' => [3.50, 1.50]
      },

      'Relic' => nil, 'Idol' => nil, 'Totem' => nil, 'Thrown' => nil, 'Sigil' => nil, 'Ranged' => {
        '226' => [0.00, 0.00],
        '232' => [0.00, 0.00],
        '239' => [0.00, 1.00],
        '245' => [0.00, 2.00],
        '258' => [0.50, 3.00],
        '264' => [1.00, 4.00],
        '277' => [1.50, 5.00],
        '284' => [2.00, 6.00]
      },
      'Trinket' => {
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

    @values['Head']     = @values['Chest']            = @values['Legs']
    @values['Shoulder'] = @values['Shoulders']        = @values['Hands']            = @values['Feet']
    @values['Wrist']    = @values['Waist']            = @values['Finger']
    # @values['Neck']     = @values['Back'] # Can't group these anymore because of pricing differences
    @values['Shield']   = @values['Held In Off-hand']
    @values['One-Hand'] = @values['Off Hand']         = @values['Melee DPS Weapon']
    @values['Relic']    = @values['Idol']             = @values['Totem']            = @values['Thrown'] = @values['Sigil'] = @values['Ranged']
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
      if options[:name] == "Fragment of Val'anyr" or options[:name] == "Shadowfrost Shard"
        price = price_legendary(options)
      else
        price = 0.00
      end
    elsif options[:slot] == 'Trinket'
      price = trinket_value(options)
    elsif special_weapon_slot?(options[:slot])
      price = special_weapon_value(options)
    else
      price = default_value(options)
    end

    price
  end

  private
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
    end

    # Simply loops through a hash of values for the given +slot+ and returns the value according to
    # nearest +level+
    def default_value(options)
      # Return early if the values for the given slot don't exist
      return nil if @values[options[:slot]].nil?

      value = nil
      slotval = @values[options[:slot]]
      slotval.sort.each do |level,values|
        # Goes to the highest possible level group for values
        if level.to_i <= options[:level]
          if values.is_a? Array
            # If it's an array, meaning the first value is for non-Hunters, and the second value is for Hunters
            value = (options[:class] == 'Hunter') ? values[1] : values[0]
          else
            value = values
          end
        end
      end

      value
    end

    # Returns the price value for legendary tokens that don't have traditional
    # level or slot stats
    def price_legendary(options)
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

    # Determines the price for Weapons that ARE NOT Two-Handers and ARE NOT Ranged
    # based on conditions such as buyer class and slot.
    def special_weapon_value(options)
      return if options[:class].nil?

      # Figure out the price on a per-class special case basis
      value = nil
      if ['Druid', 'Mage', 'Paladin', 'Priest', 'Warlock'].include? options[:class]
        # These classes have no special cases, use the defaults
        value = default_value(options)
      else
        # Find out what item level group we're dealing with
        price_group = nil
        slotval = @values['LEVELS']
        slotval.sort.each do |level|
          if level.to_i <= options[:level]
            price_group = level.to_s
          end
        end

        if options[:class] == 'Death Knight'
          value = @values['Melee DPS Weapon'][price_group][0]
        elsif options[:class] == 'Hunter'
          # Price everything as a Melee DPS weapon with the Hunter price
          value = @values['Melee DPS Weapon'][price_group][1]
        elsif options[:class] == 'Rogue'
          value = @values['Melee DPS Weapon'][price_group][0]
        elsif options[:class] == 'Shaman'
          if options[:slot] == 'Shield'
            # Shields are only used by Resto/Ele Shaman, it's a normal Shield price
            value = @values['Shield'][price_group]
          elsif options[:slot] == 'One-Hand'
            # We're gonna guess that a non-Enhancement Shaman would never use a One-Hand weapon
            value = @values['Melee DPS Weapon'][price_group][0]
          else
            value = default_value(options)
          end
        elsif options[:class] == 'Warrior'
          # Price everything as a Melee DPS weapon, even Shields
          value = @values['Melee DPS Weapon'][price_group][0]
        end
      end

      value
    end

    def trinket_value(options)
      value = nil

      if @values['Trinket'][options[:name]]
        value = @values['Trinket'][options[:name]]

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
    #   => 'Shoulders'
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
        return 'Shoulders'
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
