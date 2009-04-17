# I have no idea why this has to be here, but whatever. It seems to work.
class ItemPrice
end

module Juggy
  require 'singleton'
  
  class ItemPrice
    include Singleton
    MIN_LEVEL = 199
    
    def initialize
      @values = {
        'LEVELS' => ['199', '200', '213', '226'],
        
        'Head' => nil, 'Chest' => nil, 'Legs' => {
          '199' => 0.00, '213' => 2.00, '226' => 2.50, '239' => 3.00
        },
        'Shoulder' => nil, 'Shoulders' => nil, 'Hands' => nil, 'Feet' => {
          '199' => 0.00, '213' => 1.50, '226' => 2.00, '239' => 2.50
        },
        'Wrist' => nil, 'Waist' => nil, 'Finger' => {
          '199' => 0.00, '213' => 1.00, '226' => 1.50, '239' => 2.00
        },
        'Neck' => nil, 'Back' => {
          '199' => 0.00, '213' => 1.50, '226' => 2.00, '239' => 2.50
        },
        'Two-Hand' => {
          '199' => [0.00, 0.00], '213' => [4.00, 1.50], '226' => [5.00, 2.00], '232' => [5.00, 2.00], '239' => [6.00, 2.50]
        },
        
        # Healer/Caster
        'Main Hand' => {
          '199' => 0.00, '213' => 3.00, '226' => 3.50, '232' => 3.50, '239' => 4.00
        },
        'Shield' => nil, 'Held In Off-hand' => {
          '199' => 0.00, '213' => 1.00, '226' => 1.50, '232' => 1.50, '239' => 2.00
        },
        # Melee DPS/Hunter
        'One-Hand' => nil, 'Off Hand' => nil, 'Melee DPS Weapon' => {
          '199' => [0.00, 0.00], '213' => [2.00, 0.75], '226' => [2.50, 1.00], '232' => [2.50, 1.00], '239' => [3.00, 1.25],
        },
        
        'Relic' => nil, 'Idol' => nil, 'Totem' => nil, 'Thrown' => nil, 'Sigil' => nil, 'Ranged' => {
          '199' => [0.00, 0.00], '213' => [0.50, 3.00], '226' => [1.00, 4.00], '232' => [1.00, 4.00], '239' => [1.50, 5.00]
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
          
          # Patch 3.1 (All 2.50 temporarily)
          "Elemental Focus Stone"  => 2.50,
          "Energy Siphon"          => 2.50,
          "Eye of the Broodmother" => 2.50,
          "Flare of the Heavens"   => 2.50,
          "Heart of Iron"          => 2.50,
          "Living Flame"           => 2.50,
          "Pandora's Plea"         => 2.50,
          "Pyrite Infuser"         => 2.50,
          "Scale of Fates"         => 2.50,
          "Spark of Hope"          => 2.50,
          "The General's Heart"    => 2.50,
          "Wrathstone"             => 2.50,
        }
      }

      @values['Head'] = @values['Chest'] = @values['Legs']
      @values['Shoulder'] = @values['Shoulders'] = @values['Hands'] = @values['Feet']
      @values['Wrist'] = @values['Waist'] = @values['Finger']
      @values['Neck'] = @values['Back']
      @values['Shield'] = @values['Held In Off-hand']
      @values['One-Hand'] = @values['Off Hand'] = @values['Melee DPS Weapon']
      @values['Relic'] = @values['Idol'] = @values['Totem'] = @values['Thrown'] = @values['Sigil'] = @values['Ranged']
      
      @special_weapon_slots = ['Main Hand', 'Held In Off-hand', 'One-Hand', 'Off Hand', 'Shield']
    end

    def price(options = {})
      options[:name]   ||= nil
      options[:item]   ||= options[:name] # Item name
      options[:slot]   ||= nil            # Item slot
      options[:level]  ||= 0              # Item level (ilvl)
      options[:class]  ||= nil            # Buyer WoW class; special cases for weapons
      
      options[:level] = options[:level].to_i
      
      # Damn special items
      return 0.00 if options[:name] == "Fragment of Val'anyr"
      
      if not options[:level] or options[:level] < MIN_LEVEL or not options[:slot]
        options = special_case_options(options)
        
        # Still lower than our min level, which means it's an older item, just make it 0.00
        return 0.00 if options[:level] < MIN_LEVEL
      end
      
      return if options[:level] < MIN_LEVEL or options[:slot] == nil
      
      value = nil
      
      if options[:slot] == 'Trinket'
        value = trinket_value(options)
      elsif @special_weapon_slots.include?(options[:slot])
        value = special_weapon_value(options)
      else
        value = default_value(options)
      end

      value
    end

    private
      def default_value(options)
        value = nil
        
        slotval = @values[options[:slot]]
        slotval.sort.each do |level,values|
          if level.to_i <= options[:level]
            if values.is_a? Float
              value = values
            else
              value = (options[:class] == 'Hunter') ? values[1] : values[0]
            end
          end
        end
        
        value
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
              # We're gonna guess that a non-Enhancement Shaman would ever use a One-Hand weapon
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
        
        if @values['Trinket'][options[:item]]
          value = @values['Trinket'][options[:item]]
        else
          # raise "Invalid Trinket: #{options[:item]}"
        end

        value
      end

      def special_case_options(options)
        if options[:item] == 'Heroic Key to the Focusing Iris'
          options[:slot]  = 'Neck'
          options[:level] = 226
        elsif options[:level] == 80
          # Probably a Tier 7/8 token
          matches = options[:item].match(/^(.+) of the (Lost|Wayward) (Conqueror|Protector|Vanquisher)$/)
          if matches and matches.length > 0
            options[:slot] = determine_token_slot(matches[1])
            options[:level] = determine_token_level(matches[1], matches[2])
          end
        end

        options
      end
      
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
end