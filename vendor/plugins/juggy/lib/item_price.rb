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
      @values['One-Hand'] = @values['Off Hand'] = @values['Shield'] = @values['Held In Off-hand']
      @values['Relic'] = @values['Idol'] = @values['Totem'] = @values['Thrown'] = @values['Sigil'] = @values['Ranged']
    end

    def price(options = {})
      options[:name]   ||= nil
      options[:item]   ||= options[:name] # Item name
      options[:slot]   ||= nil            # Item slot
      options[:level]  ||= 0              # Item level (ilvl)
      options[:hunter] ||= false          # Buyer is a hunter; special cases for weapons
      
      options[:level] = options[:level].to_i
      
      if not options[:level] or options[:level] < MIN_LEVEL or not options[:slot]
        options = special_case_options(options)
      end
      
      return if options[:level] < MIN_LEVEL or options[:slot] == nil
      
      value = nil
      
      if options[:slot] == 'Trinket'
        value = trinket_value(options)
      elsif options[:slot] == 'One-Hand'
        value = onehand_value(options)
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
              value = options[:hunter] ? values[1] : values[0]
            end
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

      def onehand_value(options)
        value = nil

        slotval = @values[options[:slot]]
        slotval.sort.each do |level,values|
          if level.to_i <= options[:level]
            # One-Hand weapons have the same price for Hunters regardless of MH/OH
            if options[:hunter]
              value = values[1]
            else
              value = [ @values['Main Hand'][level][0], values[0] ]
            end
          end
        end

        value
      end

      def special_case_options(options)
        if options[:item] == 'Heroic Key to the Focusing Iris'
          options[:slot]  = 'Neck'
          options[:level] = 226
        elsif options[:level] == 80
          # Probably a Tier 7/7.5 token
          matches = options[:item].match(/^(.+) of the Lost (Conqueror|Protector|Vanquisher)$/)
          if matches.length > 0
            case matches[1]
            when 'Breastplate'
              options[:slot]  = 'Chest'
              options[:level] = 213
            when 'Chestguard'
              options[:slot]  = 'Chest'
              options[:level] = 200
            when 'Crown'
              options[:slot]  = 'Head'
              options[:level] = 213
            when 'Helm'
              options[:slot]  = 'Head'
              options[:level] = 200
            when 'Gauntlets'
              options[:slot]  = 'Hands'
              options[:level] = 213
            when 'Gloves'
              options[:slot]  = 'Hands'
              options[:level] = 200
            when 'Legplates'
              options[:slot]  = 'Legs'
              options[:level] = 213
            when 'Leggings'
              options[:slot]  = 'Legs'
              options[:level] = 200
            when 'Mantle'
              options[:slot]  = 'Shoulders'
              options[:level] = 213
            when 'Spaulders'
              options[:slot]  = 'Shoulders'
              options[:level] = 200
            end
          end
        end

        options
      end
  end
end