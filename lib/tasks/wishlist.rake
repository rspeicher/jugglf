namespace :juggernaut do
  def boss(zone, name)
    return if zone.nil? or name.blank?
    zone.children.create(:object => Boss.create(:name => name))
  end
  
  def item(boss, name, note = nil)
    return if boss.nil? or name.blank?
    boss.children.create(:object => Item.find_or_create_by_name_or_wow_id(name), 
      :note => note)
  end
  
  # Data Generators ------------------------------------------------------------
  
  def wotlk_data
    ['The Obsidian Sanctum (H)', 'The Eye of Eternity (H)'].each do |zone_name|
      zone = LootTable.create(:object => Zone.create(:name => zone_name))
      
      boss_name = ( zone_name == 'The Obsidian Sanctum (H)' ) ? 'Sartharion' : 'Malygos'
      boss = boss(zone, boss_name)
      
      case boss_name
      when 'Sartharion'
        item(boss, "Belabored Legplates")
        item(boss, "Bountiful Gauntlets")
        item(boss, "Chestguard of Flagrant Prowess")
        item(boss, "Chestplate of the Great Aspects")
        item(boss, "Concealment Shoulderpads")
        item(boss, "Council Chamber Epaulets")
        item(boss, "Dragon Brood Legguards")
        item(boss, "Dragonstorm Breastplate")
        item(boss, "Fury of the Five Flights")
        item(boss, "Gauntlets of the Lost Conqueror")
        item(boss, "Gauntlets of the Lost Protector")
        item(boss, "Gauntlets of the Lost Vanquisher")
        item(boss, "Headpiece of Reconciliation")
        item(boss, "Hyaline Helm of the Sniper")
        item(boss, "Illustration of the Dragon Soul")
        item(boss, "Leggings of the Honored")
        item(boss, "Obsidian Greathelm")
        item(boss, "Pennant Cloak")
        item(boss, "Staff of Restraint")
        item(boss, "The Sanctum's Flowing Vestments")
        item(boss, "Unsullied Cuffs")
        item(boss, "Upstanding Spaulders")
      when 'Malygos'
        item(boss, "Blanketing Robes of Snow")
        item(boss, "Blue Aspect Helm")
        item(boss, "Boots of Healing Energies")
        item(boss, "Boots of the Renewed Flight")
        item(boss, "Chestguard of the Recluse")
        item(boss, "Elevated Lair Pauldrons")
        item(boss, "Footsteps of Malygos")
        item(boss, "Frosted Adroit Handguards")
        item(boss, "Hailstorm")
        item(boss, "Hood of Rationality")
        item(boss, "Ice Spire Scepter")
        item(boss, "Leash of Heedless Magic")
        item(boss, "Leggings of the Wanton Spellcaster")
        item(boss, "Legplates of Sovereignty")
        item(boss, "Living Ice Crystals")
        item(boss, "Mantle of Dissemination")
        item(boss, "Mark of Norgannon")
        item(boss, "Melancholy Sabatons")
        item(boss, "Spaulders of Catatonia")
        item(boss, "Tunic of the Artifact Guardian")
        item(boss, "Unravelling Strands of Sanity")
        item(boss, "Winter Spectacle Gloves")
      end
    end
  end
  
  def ulduar_data
    ulduar_bosses = ['Bind on Equip', 
      'Flame Leviathan','Ignis the Furnacemaster','Razorscale','XT-002 Deconstructor', 
      'Kologarn','Auriaya','Assembly of Iron',
      'Hodir','Thorim','Freya','Mimiron',
      'General Vezax', 'Yogg-Saron', 'Algalon the Observer']
    
    ['Ulduar'].each do |zone_name|
      zone = LootTable.create(:object => Zone.create(:name => zone_name))
      
      ulduar_bosses.each do |boss_name|
        boss = boss(zone, boss_name)
        
        case boss_name
        when 'Bind on Equip'
        when 'Flame Leviathan'
          item(boss, "Combustion Bracers")
          item(boss, "Energy Siphon")
          item(boss, "Firesoul")
          item(boss, "Firestrider Chestguard")
          item(boss, "Flamewatch Armguards")
          item(boss, "Gilded Steel Legplates")
          item(boss, "Handguards of Potent Cures")
          item(boss, "Ironsoul")
          item(boss, "Kinetic Ripper")
          item(boss, "Lifespark Visage")
          item(boss, "Mantle of Fiery Vengeance")
          item(boss, "Might of the Leviathan")
          item(boss, "Pyrite Infuser")
          item(boss, "Shimmering Seal")
          item(boss, "Twirling Blades")
        when 'Ignis the Furnacemaster'
          item(boss, "Armbraces of the Vibrant Flame")
          item(boss, "Drape of Fuming Anger")
          item(boss, "Furnace Stone")
          item(boss, "Gauntlets of the Iron Furnace")
          item(boss, "Gloves of Smoldering Touch")
          item(boss, "Igniter Rod")
          item(boss, "Pauldrons of Tempered Will")
          item(boss, "Relentless Edge")
          item(boss, "Rifle of the Platinum Guard")
        when 'Razorscale'
          item(boss, "Band of Draconic Guile")
          item(boss, "Binding of the Dragon Matriarch")
          item(boss, "Bracers of the Smothering Inferno")
          item(boss, "Breastplate of the Afterlife")
          item(boss, "Dragonsteel Faceplate")
          item(boss, "Eye of the Broodmother")
          item(boss, "Ironscale Leggings")
          item(boss, "Razorscale Talon")
          item(boss, "Stormtempered Girdle")
          item(boss, "Treads of the Invader")
        when 'XT-002 Deconstructor'
          item(boss, "Aesir's Edge")
          item(boss, "Armbands of the Construct")
          item(boss, "Breastplate of the Stoneshaper")
          item(boss, "Chestplate of Vicious Potency")
          item(boss, "Conductive Cord")
          item(boss, "Fluxing Energy Coils")
          item(boss, "Gloves of Taut Grip")
          item(boss, "Helm of Veiled Energies")
          item(boss, "Magnetized Projectile Emitter")
          item(boss, "Plasma Foil")
          item(boss, "Power Enhancing Loop")
          item(boss, "Pulsing Spellshield")
          item(boss, "Treacherous Shoulderpads")
          item(boss, "Vest of the Glowing Crescent")
        when 'Kologarn'
          item(boss, "Emerald Signet Ring")
          item(boss, "Greaves of the Earthbinder")
          item(boss, "Mark of the Unyielding")
          item(boss, "Pendant of the Piercing Glare")
          item(boss, "Sabatons of the Iron Watcher")
          item(boss, "Shawl of the Shattered Giant")
          item(boss, "Shoulderguards of the Solemn Watch")
          item(boss, "Spark of Hope")
          item(boss, "Spire of Withering Dreams")
          item(boss, "Stoneguard")
        when 'Auriaya'
          item(boss, "Archaedas' Lost Legplates")
          item(boss, "Chestplate of Titanic Fury")
          item(boss, "Cover of the Keepers")
          item(boss, "Elemental Focus Stone")
          item(boss, "Ironaya's Discarded Mantle")
          item(boss, "Mantle of the Preserver")
          item(boss, "Nimble Climber's Belt")
          item(boss, "Nurturing Touch")
          item(boss, "Raiments of the Corrupted")
          item(boss, "Shieldwall of the Breaker")
        when 'Assembly of Iron'
          item(boss, "Belt of the Crystal Tree")
          item(boss, "Belt of the Iron Servant")
          item(boss, "Boots of the Petrified Forest")
          item(boss, "Circlet of True Sight")
          item(boss, "Cloak of the Iron Council")
          item(boss, "Greaves of Iron Intensity")
          item(boss, "Lady Maye's Sapphire Ring")
          item(boss, "Leggings of Swift Reflexes")
          item(boss, "Loop of the Agile")
          item(boss, "Perilous Bite")
          item(boss, "Rune-Etched Nightblade")
          item(boss, "Runetouch Handwraps")
          item(boss, "Stormtip")
          item(boss, "The Masticator")
          item(boss, "45447") # Watchful Eye
        when 'Hodir'
          item(boss, "Avalanche")
          item(boss, "Bitter Cold Armguards")
          item(boss, "Cowl of Icy Breaths")
          item(boss, "Ice Layered Barrier")
          item(boss, "Icecore Staff")
          item(boss, "Leggings of the Wayward Conqueror")
          item(boss, "Leggings of the Wayward Protector")
          item(boss, "Leggings of the Wayward Vanquisher")
          item(boss, "Shiver")
          item(boss, "Signet of Winter")
          item(boss, "Stormedge")
          item(boss, "The Boreal Guard")
          item(boss, "Winter's Frigid Embrace")
        when 'Thorim'
          item(boss, "Belt of the Blood Pit")
          item(boss, "Combatant's Bootblade")
          item(boss, "Gauntlets of the Thunder God")
          item(boss, "Guise of the Midgard Serpent")
          item(boss, "Handwraps of Resonance")
          item(boss, "Hoperender")
          item(boss, "Legacy of Thunder")
          item(boss, "Leggings of Unstable Discharge")
          item(boss, "Mjolnir Runestone")
          item(boss, "Pendant of the Shallow Grave")
          item(boss, "Sif's Remembrance")
          item(boss, "Spaulders of the Wayward Conqueror")
          item(boss, "Spaulders of the Wayward Protector")
          item(boss, "Spaulders of the Wayward Vanquisher")
        when 'Freya'
          item(boss, "Chestguard of the Lasher")
          item(boss, "Fire Orchid Signet")
          item(boss, "Gloves of Whispering Winds")
          item(boss, "Gloves of the Wayward Conqueror")
          item(boss, "Gloves of the Wayward Protector")
          item(boss, "Gloves of the Wayward Vanquisher")
          item(boss, "Ironbark Faceguard")
          item(boss, "Legplates of Flourishing Resolve")
          item(boss, "Petrified Ivy Sprig")
          item(boss, "Seed of Budding Carnage")
          item(boss, "Serilas, Blood Blade of Invar One-Arm")
          item(boss, "Tunic of the Limber Stalker")
          item(boss, "Unraveling Reach")
        when 'Mimiron'
          item(boss, "Cable of the Metrognome")
          item(boss, "Fused Alloy Legplates")
          item(boss, "Fusion Blade")
          item(boss, "Greaves of the Iron Army")
          item(boss, "Helm of the Wayward Conqueror")
          item(boss, "Helm of the Wayward Protector")
          item(boss, "Helm of the Wayward Vanquisher")
          item(boss, "Mimiron's Flight Goggles")
          item(boss, "Pulse Baton")
          item(boss, "Shoulderguards of Assimilation")
          item(boss, "Static Charge Handwraps")
          item(boss, "Stylish Power Cape")
          item(boss, "Tempered Mercury Greaves")
        when 'General Vezax'
          item(boss, "Aesuga, Hand of the Ardent Champion")
          item(boss, "Bindings of the Depths")
          item(boss, "Boots of Unsettled Prey")
          item(boss, "Choker of the Abyss")
          item(boss, "Darkstone Ring")
          item(boss, "Drape of the Faceless General")
          item(boss, "Leggings of Profound Darkness")
          item(boss, "Pendant of Endless Despair")
          item(boss, "Saronite Animus Cloak")
          item(boss, "Shadowbite")
          item(boss, "Tortured Earth")
          item(boss, "Underworld Mantle")
          item(boss, "Vestments of the Piercing Light")
          item(boss, "Void Sabre")
        when 'Yogg-Saron'
          item(boss, "Abaddon")
          item(boss, "Amice of Inconceivable Horror")
          item(boss, "Caress of Insanity")
          item(boss, "Chestguard of the Wayward Conqueror")
          item(boss, "Chestguard of the Wayward Protector")
          item(boss, "Chestguard of the Wayward Vanquisher")
          item(boss, "Deliverance")
          item(boss, "Devotion")
          item(boss, "Faceguard of the Eyeless Horror")
          item(boss, "Hammer of Crushing Whispers")
          item(boss, "Kingsbane")
          item(boss, "Leggings of the Insatiable")
          item(boss, "Pendant of a Thousand Maws")
          item(boss, "Royal Seal of King Llane")
          item(boss, "Signet of Soft Lament")
          item(boss, "Soul-Devouring Cinch")
          item(boss, "Touch of Madness")
          item(boss, "Treads of the Dragon Council")
        when 'Algalon the Observer'
          item(boss, "Band of Lights")
          item(boss, "Breastplate of the Timeless")
          item(boss, "46038") # Dark Matter
          item(boss, "Drape of the Messenger")
          item(boss, "Gloves of the Endless Dark")
          item(boss, "Meteorite Crystal")
          item(boss, "Nebula Band")
          item(boss, "Observer's Mantle")
          item(boss, "Pendant of the Somber Witness")
          item(boss, "Pulsar Gloves")
          item(boss, "Reply-Code Alpha")
          item(boss, "Shoulderplates of the Celestial Watch")
          item(boss, "Starfall Girdle")
          item(boss, "Starlight Treads")
          item(boss, "Strength of the Heavens")
          item(boss, "Zodiac Leggings")
        end
      end
    end
    
    ['Ulduar (H)'].each do |zone_name|
      zone = LootTable.create(:object => Zone.create(:name => zone_name))
      
      ulduar_bosses.each do |boss_name|
        boss = boss(zone, boss_name)
        
        case boss_name
        when 'Bind on Equip'
          item(boss, "Asimov's Drape", "Mimiron")
          item(boss, "Cowl of the Absolute", "Auriaya")
          item(boss, "Darkcore Leggings", "General Vezax")
          item(boss, "Iron Riveted War Helm", "Flame Leviathan")
          item(boss, "Leggings of Lost Love", "Thorim")
          item(boss, "Leggings of the Stoneweaver", "Kologarn")
          item(boss, "Lifeforge Breastplate", "Ignis the Furnacemaster")
          item(boss, "Northern Barrier", "Hodir")
          item(boss, "Nymph Heart Charm", "Freya")
          item(boss, "Phaelia's Vestments of the Sprouting Seed", "Assembly of Iron")
          item(boss, "Proto-hide Leggings", "Razorscale")
          item(boss, "Signet of the Earthshaker", "XT-002 Deconstructor")
        when 'Flame Leviathan'
          item(boss, "Boots of Fiery Resolution", "Hard Mode")
          item(boss, "Constructor's Handwraps")
          item(boss, "Embrace of the Leviathan")
          item(boss, "Freya's Choker of Warding")
          item(boss, "Gloves of the Fiery Behemoth")
          item(boss, "Glowing Ring of Reclamation")
          item(boss, "Golden Saronite Dragon", "Hard Mode")
          item(boss, "Mechanist's Bindings")
          item(boss, "Mimiron's Inferno Couplings")
          item(boss, "Overcharged Fuel Rod")
          item(boss, "Pendant of Fiery Havoc", "Hard Mode")
          item(boss, "Plated Leggings of Ruination", "Hard Mode")
          item(boss, "Shoulderpads of Dormant Energies", "Hard Mode")
          item(boss, "Steamcaller's Totem")
          item(boss, "Steamworker's Goggles")
          item(boss, "Strength of the Automaton")
          item(boss, "The Leviathan's Coil")
          item(boss, "Titanguard")
        when 'Ignis the Furnacemaster'
          item(boss, "Cindershard Ring")
          item(boss, "Flamestalker Boots")
          item(boss, "Flamewrought Cinch")
          item(boss, "Girdle of Embers")
          item(boss, "Heart of Iron")
          item(boss, "Helm of the Furnace Master")
          item(boss, "Intensity")
          item(boss, "Pyrelight Circle")
          item(boss, "Scepter of Creation")
          item(boss, "Soot-covered Mantle")
          item(boss, "Totem of the Dancing Flame")
          item(boss, "Worldcarver")
          item(boss, "Wristguards of the Firetender")
        when 'Razorscale'
          item(boss, "Belt of the Fallen Wyrm")
          item(boss, "Bracers of the Broodmother")
          item(boss, "Charred Saronite Greaves")
          item(boss, "Collar of the Wyrmhunter")
          item(boss, "Dragonslayer's Brace")
          item(boss, "Drape of the Drakerider")
          item(boss, "Guiding Star")
          item(boss, "Living Flame")
          item(boss, "Razorscale Shoulderguards")
          item(boss, "Remorse")
          item(boss, "Saronite Mesh Legguards")
          item(boss, "Shackles of the Odalisque")
          item(boss, "Sigil of Deflection")
          item(boss, "Veranus' Bane")
        when 'XT-002 Deconstructor'
          item(boss, "Boots of Hasty Revival")
          item(boss, "Brass-lined Boots")
          item(boss, "Breastplate of the Devoted", "Hard Mode")
          item(boss, "Charm of Meticulous Timing", "Hard Mode")
          item(boss, "Clockwork Legplates")
          item(boss, "Crazed Construct Ring")
          item(boss, "Gloves of the Steady Hand", "Hard Mode")
          item(boss, "Golem-Shard Sticker")
          item(boss, "Grasps of Reason", "Hard Mode")
          item(boss, "Horologist's Wristguards")
          item(boss, "Mantle of Wavering Calm")
          item(boss, "Quartz Crystal Wand")
          item(boss, "Quartz-studded Harness")
          item(boss, "Sandals of Rash Temperament")
          item(boss, "Shoulderplates of the Deconstructor")
          item(boss, "Sigil of the Vengeful Heart")
          item(boss, "Sorthalis, Hammer of the Watchers", "Hard Mode")
          item(boss, "Thunderfall Totem")
          item(boss, "Twisted Visage")
        when 'Kologarn'
          item(boss, "Bracers of Unleashed Magic")
          item(boss, "Decimator's Armguards")
          item(boss, "Giant's Bane")
          item(boss, "Gloves of the Pythonic Guardian")
          item(boss, "Handwraps of Plentiful Recovery")
          item(boss, "Idol of the Crying Wind")
          item(boss, "Ironmender")
          item(boss, "Malice")
          item(boss, "Necklace of Unerring Mettle")
          item(boss, "Robes of the Umbral Brute")
          item(boss, "Saronite Plated Legguards")
          item(boss, "Shoulderpads of the Monolith")
          item(boss, "Unfaltering Armguards")
          item(boss, "Wrathstone")
        when 'Auriaya'
          item(boss, "Amice of the Stoic Watch")
          item(boss, "Cloak of the Makers")
          item(boss, "Gloves of the Stonereaper")
          item(boss, "Greaves of the Rockmender")
          item(boss, "Libram of the Resolute")
          item(boss, "Platinum Band of the Aesir")
          item(boss, "Ring of the Faithful Servant")
          item(boss, "Runescribed Blade")
          item(boss, "Sandals of the Ancient Keeper")
          item(boss, "Shoulderplates of the Eternal")
          item(boss, "Siren's Cry")
          item(boss, "Stonerender")
          item(boss, "Unbreakable Chestguard")
          item(boss, "Unwavering Stare")
        when 'Assembly of Iron'
          item(boss, "Ancient Iron Heaume")
          item(boss, "Belt of Colossal Rage", "Hard Mode")
          item(boss, "Drape of Mortal Downfall", "Hard Mode")
          item(boss, "Drape of the Lithe")
          item(boss, "Fang of Oblivion", "Hard Mode")
          item(boss, "Greaves of Swift Vengeance", "Hard Mode")
          item(boss, "Handguards of the Enclave")
          item(boss, "Insurmountable Fervor")
          item(boss, "Iron-studded Mantle")
          item(boss, "Overload Legwraps")
          item(boss, "Radiant Seal")
          item(boss, "Raiments of the Iron Council")
          item(boss, "Rapture")
          item(boss, "45233") # Rune Edge
          item(boss, "Runed Ironhide Boots")
          item(boss, "Runeshaper's Gloves")
          item(boss, "Sapphire Amulet of Renewal", "Hard Mode")
          item(boss, "Shoulderpads of the Intruder", "Hard Mode")
          item(boss, "Steelbreaker's Embrace")
          item(boss, "Unblinking Eye")
        when 'Hodir'
          item(boss, "Bindings of Winter Gale", "Hard Mode")
          item(boss, "Breastplate of the Wayward Conqueror")
          item(boss, "Breastplate of the Wayward Protector")
          item(boss, "Breastplate of the Wayward Vanquisher")
          item(boss, "Constellus", "Hard Mode")
          item(boss, "Drape of Icy Intent", "Hard Mode")
          item(boss, "Frigid Strength of Hodir", "Hard Mode")
          item(boss, "Frost-bound Chain Bracers")
          item(boss, "Frostplate Greaves")
          item(boss, "Frozen Loop")
          item(boss, "Gloves of the Frozen Glade", "Hard Mode")
          item(boss, "Staff of Endless Winter", "Hard Mode")
          item(boss, "Winter's Icy Embrace")
        when 'Thorim'
          item(boss, "Belt of the Betrayed")
          item(boss, "Crown of the Wayward Conqueror")
          item(boss, "Crown of the Wayward Protector")
          item(boss, "Crown of the Wayward Vanquisher")
          item(boss, "Embrace of the Gladiator", "Hard Mode")
          item(boss, "Fate's Clutch", "Hard Mode")
          item(boss, "Pauldrons of the Combatant", "Hard Mode")
          item(boss, "Scale of Fates")
          item(boss, "Sif's Promise")
          item(boss, "Skyforge Crossbow")
          item(boss, "Vulmir, the Northern Tempest")
          item(boss, "Warhelm of the Champion", "Hard Mode")
          item(boss, "Wisdom's Hold", "Hard Mode")
        when 'Freya'
          item(boss, "Bladetwister", "Hard Mode")
          item(boss, "Boots of the Servant")
          item(boss, "Bronze Pendant of the Vanir", "Hard Mode")
          item(boss, "Drape of the Sullen Goddess", "Hard Mode")
          item(boss, "Dreambinder", "Hard Mode")
          item(boss, "Gauntlets of Ruthless Reprisal")
          item(boss, "Handguards of Revitalization", "Hard Mode")
          item(boss, "Leggings of the Enslaved Idol", "Hard Mode")
          item(boss, "Leggings of the Lifetender")
          item(boss, "Legplates of the Wayward Conqueror")
          item(boss, "Legplates of the Wayward Protector")
          item(boss, "Legplates of the Wayward Vanquisher")
          item(boss, "The Lifebinder")
        when 'Mimiron'
          item(boss, "Armbands of Bedlam", "Hard Mode")
          item(boss, "Conductive Seal", "Hard Mode")
          item(boss, "Crown of Luminescence", "Hard Mode")
          item(boss, "Delirium's Touch", "Hard Mode")
          item(boss, "Gauntlets of the Wayward Conqueror")
          item(boss, "Gauntlets of the Wayward Protector")
          item(boss, "Gauntlets of the Wayward Vanquisher")
          item(boss, "Insanity's Grip")
          item(boss, "Malleable Steelweave Mantle")
          item(boss, "Pandora's Plea")
          item(boss, "Titanskin Cloak", "Hard Mode")
          item(boss, "Starshard Edge", "Hard Mode")
          item(boss, "Waistguard of the Creator")
        when 'General Vezax'
          item(boss, "Belt of Clinging Hope")
          item(boss, "Belt of the Darkspeaker")
          item(boss, "Boots of the Forgotten Depths")
          item(boss, "Boots of the Underdweller")
          item(boss, "Flare of the Heavens", "Hard Mode")
          item(boss, "Grips of the Unbroken")
          item(boss, "Handwraps of the Vigilant", "Hard Mode")
          item(boss, "Helm of the Faceless")
          item(boss, "Idol of the Corruptor")
          item(boss, "Libram of Discord")
          item(boss, "Libram of the Sacred Shield")
          item(boss, "Lotrafen, Spear of the Damned")
          item(boss, "Mantle of the Unknowing")
          item(boss, "Metallic Loop of the Sufferer")
          item(boss, "Pendulum of Infinity", "Hard Mode")
          item(boss, "Ring of the Vacant Eye")
          item(boss, "Scepter of Lost Souls")
          item(boss, "The General's Heart")
          item(boss, "Vestments of the Blind Denizen", "Hard Mode")
          item(boss, "Voldrethar, Dark Blade of Oblivion", "Hard Mode")
        when 'Yogg-Saron'
          item(boss, "Blood of the Old God")
          item(boss, "Chestguard of Insidious Intent")
          item(boss, "Chestguard of the Fallen God")
          item(boss, "Cowl of Dark Whispers")
          item(boss, "Dark Edge of Depravity", "Hard Mode")
          item(boss, "Earthshaper")
          item(boss, "Garona's Guise")
          item(boss, "Godbane Signet")
          item(boss, "Legguards of Cunning Deception", "Hard Mode")
          item(boss, "Mantle of the Wayward Conqueror")
          item(boss, "Mantle of the Wayward Protector")
          item(boss, "Mantle of the Wayward Vanquisher")
          item(boss, "Sanity's Bond")
          item(boss, "Seal of the Betrayed King", "Hard Mode")
          item(boss, "Shawl of Haunted Memories")
          item(boss, "Show of Faith", "Hard Mode")
          item(boss, "Soulscribe")
          item(boss, "Treads of the False Oracle", "Hard Mode")
          item(boss, "Vanquished Clutches of Yogg-Saron")
        when 'Algalon the Observer'
          item(boss, "Boundless Gaze")
          item(boss, "Bulwark of Algalon")
          item(boss, "Constellus")
          item(boss, "Cosmos")
          item(boss, "Dreambinder")
          item(boss, "Fang of Oblivion")
          item(boss, "Legplates of the Endless Void")
          item(boss, "Pharos Gloves")
          item(boss, "Reply-Code Alpha")
          item(boss, "Sabatons of Lifeless Night")
          item(boss, "Skyforge Crossbow")
          item(boss, "Solar Bindings")
          item(boss, "Star-beaded Clutch")
          item(boss, "Starshard Edge")
          item(boss, "Starwatcher's Binding")
        end
      end
    end
  end
  
  def crusade_data
    toc_bosses = {
      'Trial of the Crusader' => [
        ['northrendbeasts-10'       , 'Northrend Beasts'],
        ['jaraxxus-10'              , 'Jaraxxus'],
        ['factionchampions-10'      , 'Faction Champions'],
        ['twinvalkyrs-10'           , 'Twin Valkyrs'],
        ['anubarakraid-10'          , "Anub'arak"]
      ],
      'Trial of the Crusader (H)' => [
        ['northrendbeasts-10-hard'  , 'Northrend Beasts'],
        ['jaraxxus-10-hard'         , 'Jaraxxus'],
        ['factionchampions-10-hard' , 'Faction Champions'],
        ['twinvalkyrs-10-hard'      , 'Twin Valkyrs'],
        ['anubarakraid-10-hard'     , "Anub'arak"],
        ['tributechest-10'          , 'Tribute Chest'],
        ['tributechest-10-hard'     , 'Tribute Chest (Hard)']
      ],
      'Trial of the Grand Crusader' => [
        ['northrendbeasts-25'       , 'Northrend Beasts'],
        ['jaraxxus-25'              , 'Jaraxxus'],
        ['factionchampions-25'      , 'Faction Champions'],
        ['twinvalkyrs-25'           , 'Twin Valkyrs'],
        ['anubarakraid-25'          , "Anub'arak"]
      ],
      'Trial of the Grand Crusader (H)' => [
        ['northrendbeasts-25-hard'  , 'Northrend Beasts'],
        ['jaraxxus-25-hard'         , 'Jaraxxus'],
        ['factionchampions-25-hard' , 'Faction Champions'],
        ['twinvalkyrs-25-hard'      , 'Twin Valkyrs'],
        ['anubarakraid-25-hard'     , "Anub'arak"],
        ['tributechest-25'          , 'Tribute Chest'],
        ['tributechest-25-hard'     , 'Tribute Chest (Hard)']
      ]
    }
    
    toc_bosses.sort.each do |zone_name, bosses|
      zone = LootTable.create(:object => Zone.create(:name => zone_name))
      bosses.each do |boss_tag, boss_name|
        boss = boss(zone, boss_name)
        case boss_tag
        when "factionchampions-10"
          item(boss, 47880) #Binding Stone
          item(boss, 47882) #Eitrigg's Oath
          item(boss, 47879) #Fetish of Volatile Power
          item(boss, 47878) #Sunreaver Assassin's Gloves
          item(boss, 47876) #Sunreaver Champion's Faceplate
          item(boss, 47877) #Sunreaver Defender's Pauldrons
          item(boss, 47874) #Sunreaver Disciple's Blade
          item(boss, 47873) #Sunreaver Magus' Sandals
          item(boss, 47875) #Sunreaver Ranger's Helm
          item(boss, 47881) #Vengeance of the Forsaken
        when "factionchampions-25-hard"
          item(boss, 47443) #Band of Callous Aggression
          item(boss, 47448) #Bastion of Resolve
          item(boss, 47447) #Belt of Biting Cold
          item(boss, 47444) #Belt of Bloodied Scars
          item(boss, 47455) #Bracers of the Broken Bond
          item(boss, 47442) #Bracers of the Silent Massacre
          item(boss, 47449) #Chestplate of the Frostwolf Hero
          item(boss, 47446) #Dual-blade Butcher
          item(boss, 47445) #Icewalker Treads
          item(boss, 47451) #Juggernaut's Vitality
          item(boss, 47450) #Leggings of Concealed Hatred
          item(boss, 47453) #Robes of the Shattered Fellowship
          item(boss, 47456) #Sabatons of Tremoring Earth
          item(boss, 47454) #Sandals of the Mourning Widow
          item(boss, 47452) #Shroud of Displacement
        when "twinvalkyrs-10-hard"
          item(boss, 48027) #Band of the Twin Val'kyr
          item(boss, 48030) #Darkbane Amulet
          item(boss, 48023) #Edge of Agony
          item(boss, 48024) #Greaves of the Lingering Vortex
          item(boss, 48034) #Helm of the High Mesa
          item(boss, 48036) #Illumination
          item(boss, 48032) #Lightbane Focus
          item(boss, 48028) #Looming Shadow Wraps
          item(boss, 48025) #Nemesis Blade
          item(boss, 49233) #Sandals of the Grieving Soul
          item(boss, 48038) #Sen'jin Ritualist Gloves
          item(boss, 48026) #Vest of Shifting Shadows
          item(boss, 48022) #Widebarrel Flintlock
        when "anubarakraid-10"
          item(boss, 47910) #Aegis of the Coliseum
          item(boss, 47911) #Anguish
          item(boss, 47899) #Ardent Guard
          item(boss, 47909) #Belt of the Eternal
          item(boss, 47905) #Blackhorn Bludgeon
          item(boss, 47907) #Darkmaw Crossbow
          item(boss, 47903) #Forsaken Bonecarver
          item(boss, 47898) #Frostblade Hatchet
          item(boss, 47897) #Helm of the Crypt Lord
          item(boss, 47902) #Legplates of Redeemed Blood
          item(boss, 47894) #Mace of the Earthborn Chieftain
          item(boss, 47901) #Pauldrons of the Shadow Hunter
          item(boss, 47900) #Perdition
          item(boss, 47895) #Pride of the Kor'kron
          item(boss, 47906) #Robes of the Sleepless
          item(boss, 47904) #Shoulderpads of the Snow Bandit
          item(boss, 47896) #Stoneskin Chestplate
          item(boss, 47908) #Sunwalker Legguards
        when "northrendbeasts-25-hard"
          item(boss, 47422) #Barb of Tarasque
          item(boss, 47419) #Belt of the Tenebrous Mist
          item(boss, 47426) #Binding of the Ice Burrower
          item(boss, 47414) #Boneshatter Vambraces
          item(boss, 47423) #Boots of the Harsh Winter
          item(boss, 47418) #Cloak of the Untamed Predator
          item(boss, 47412) #Cuirass of Cruel Intent
          item(boss, 47417) #Drape of the Refreshing Winds
          item(boss, 47425) #Flowing Robes of Ascent
          item(boss, 47421) #Forlorn Barrier
          item(boss, 47415) #Hauberk of the Towering Monstrosity
          item(boss, 47420) #Legwraps of the Broken Beast
          item(boss, 47413) #Ring of the Violent Temperament
          item(boss, 47424) #Sabatons of the Courageous
          item(boss, 47416) #Stygian Bladebreaker
        when "jaraxxus-25"
          item(boss, 47277) #Bindings of the Autumn Willow
          item(boss, 47266) #Blood Fury
          item(boss, 47268) #Bloodbath Girdle
          item(boss, 47272) #Charge of the Eredar
          item(boss, 47278) #Circle of the Darkmender
          item(boss, 47269) #Dawnbreaker Sabatons
          item(boss, 47267) #Death's Head Crossbow
          item(boss, 47279) #Leggings of Failing Light
          item(boss, 47273) #Legplates of Feverish Dedication
          item(boss, 47274) #Pants of the Soothing Touch
          item(boss, 47275) #Pride of the Demon Lord
          item(boss, 47271) #Solace of the Fallen
          item(boss, 47276) #Talisman of Heedless Sins
          item(boss, 47270) #Vest of Calamitous Fate
          item(boss, 47280) #Wristwraps of Cloudy Omen
        when "northrendbeasts-10"
          item(boss, 47853) #Acidmaw Treads
          item(boss, 47859) #Belt of the Impaler
          item(boss, 47850) #Bracers of the Northern Stalker
          item(boss, 47849) #Collar of Unending Torment
          item(boss, 47852) #Dreadscale Bracers
          item(boss, 47851) #Gauntlets of Mounting Anger
          item(boss, 47858) #Girdle of the Frozen Reach
          item(boss, 47854) #Gormok's Band
          item(boss, 47855) #Icehowl Binding
          item(boss, 47857) #Pauldrons of the Glacial Wilds
          item(boss, 47860) #Pauldrons of the Spirit Walker
          item(boss, 47856) #Scepter of Imprisoned Souls
        when "factionchampions-10-hard"
          item(boss, 48019) #Binding Stone
          item(boss, 48021) #Eitrigg's Oath
          item(boss, 48018) #Fetish of Volatile Power
          item(boss, 48017) #Sunreaver Assassin's Gloves
          item(boss, 48015) #Sunreaver Champion's Faceplate
          item(boss, 48016) #Sunreaver Defender's Pauldrons
          item(boss, 48013) #Sunreaver Disciple's Blade
          item(boss, 48012) #Sunreaver Magus' Sandals
          item(boss, 48014) #Sunreaver Ranger's Helm
          item(boss, 48020) #Vengeance of the Forsaken
        when "anubarakraid-10-hard"
          item(boss, 48055) #Aegis of the Coliseum
          item(boss, 48056) #Anguish
          item(boss, 48044) #Ardent Guard
          item(boss, 48054) #Belt of the Eternal
          item(boss, 48050) #Blackhorn Bludgeon
          item(boss, 48052) #Darkmaw Crossbow
          item(boss, 48048) #Forsaken Bonecarver
          item(boss, 48043) #Frostblade Hatchet
          item(boss, 48042) #Helm of the Crypt Lord
          item(boss, 48047) #Legplates of the Redeemed Blood Knight
          item(boss, 48039) #Mace of the Earthborn Chieftain
          item(boss, 48046) #Pauldrons of the Shadow Hunter
          item(boss, 48045) #Perdition
          item(boss, 48040) #Pride of the Kor'kron
          item(boss, 48051) #Robes of the Sleepless
          item(boss, 48049) #Shoulderpads of the Snow Bandit
          item(boss, 48041) #Stoneskin Chestplate
          item(boss, 48053) #Sunwalker Legguards
        when "twinvalkyrs-10"
          item(boss, 47888) #Band of the Twin Val'kyr
          item(boss, 47890) #Darkbane Amulet
          item(boss, 47884) #Edge of Agony
          item(boss, 47885) #Greaves of the Lingering Vortex
          item(boss, 47891) #Helm of the High Mesa
          item(boss, 47892) #Illumination
          item(boss, 47913) #Lightbane Focus
          item(boss, 47889) #Looming Shadow Wraps
          item(boss, 47886) #Nemesis Blade
          item(boss, 49232) #Sandals of the Grieving Soul
          item(boss, 47893) #Sen'jin Ritualist Gloves
          item(boss, 47887) #Vest of Shifting Shadows
          item(boss, 47883) #Widebarrel Flintlock
        when "twinvalkyrs-25-hard"
          item(boss, 47459) #Armguards of the Shieldmaiden
          item(boss, 47469) #Belt of Pale Thorns
          item(boss, 47460) #Belt of the Pitiless Killer
          item(boss, 47471) #Chestplate of the Frozen Lake
          item(boss, 47468) #Cry of the Val'kyr
          item(boss, 47467) #Dark Essence Bindings
          item(boss, 47464) #Death's Choice
          item(boss, 47461) #Gouge of the Frigid Heart
          item(boss, 47457) #Greaves of Ruthless Judgment
          item(boss, 47466) #Legionnaire's Gorget
          item(boss, 47465) #Legplates of Ascension
          item(boss, 47470) #Mystifying Charm
          item(boss, 47462) #Skyweaver Vestments
          item(boss, 47458) #The Executioner's Vice
          item(boss, 47463) #Twin's Pact
        when "jaraxxus-25-hard"
          item(boss, 47438) #Bindings of the Autumn Willow
          item(boss, 47427) #Blood Fury
          item(boss, 47429) #Bloodbath Girdle
          item(boss, 47433) #Charge of the Eredar
          item(boss, 47439) #Circle of the Darkmender
          item(boss, 47430) #Dawnbreaker Sabatons
          item(boss, 47428) #Death's Head Crossbow
          item(boss, 47440) #Leggings of Failing Light
          item(boss, 47434) #Legplates of Feverish Dedication
          item(boss, 47435) #Pants of the Soothing Touch
          item(boss, 47436) #Pride of the Demon Lord
          item(boss, 47432) #Solace of the Fallen
          item(boss, 47437) #Talisman of Heedless Sins
          item(boss, 47431) #Vest of Calamitous Fate
          item(boss, 47441) #Wristwraps of Cloudy Omen
        when "northrendbeasts-10-hard"
          item(boss, 47992) #Acidmaw Treads
          item(boss, 47998) #Belt of the Impaler
          item(boss, 47989) #Bracers of the Northern Stalker
          item(boss, 47993) #Carnivorous Band
          item(boss, 47988) #Collar of Unending Torment
          item(boss, 47991) #Dreadscale Bracers
          item(boss, 47990) #Gauntlets of Mounting Anger
          item(boss, 47997) #Girdle of the Frozen Reach
          item(boss, 47994) #Icehowl Binding
          item(boss, 47996) #Pauldrons of the Glacial Wilds
          item(boss, 47999) #Pauldrons of the Spirit Walker
          item(boss, 47995) #Scepter of Imprisoned Souls
        when "tributechest-25-hard"
          item(boss, 47551) #Aethas' Intensity
          item(boss, 47550) #Cairne's Endurance
          item(boss, 47548) #Garrosh's Rage
          item(boss, 47554) #Lady Liadrin's Conviction
          item(boss, 47546) #Sylvanas' Cunning
        when "anubarakraid-25"
          item(boss, 47313) #Armbands of Dark Determination
          item(boss, 47315) #Band of the Traitor King
          item(boss, 47324) #Bindings of the Ashen Saint
          item(boss, 47321) #Boots of the Icy Floe
          item(boss, 47317) #Breeches of the Deepening Void
          item(boss, 47325) #Cuirass of Flowing Elements
          item(boss, 47330) #Gauntlets of Bitter Reprisal
          item(boss, 47323) #Girdle of the Forgotten Martyr
          item(boss, 47312) #Greaves of the Saronite Citadel
          item(boss, 47326) #Handwraps of the Lifeless Touch
          item(boss, 47329) #Hellion Glaive
          item(boss, 47314) #Hellscream Slicer
          item(boss, 47318) #Leggings of the Awakening
          item(boss, 47319) #Leggings of the Lurking Threat
          item(boss, 47327) #Lurid Manifestation
          item(boss, 47328) #Maiden's Adoration
          item(boss, 47320) #Might of the Nerub
          item(boss, 47316) #Reign of the Dead
          item(boss, 47322) #Suffering's End
          item(boss, 47311) #Waistguard of Deathly Dominion
        when "factionchampions-25"
          item(boss, 47282) #Band of Callous Aggression
          item(boss, 47287) #Bastion of Resolve
          item(boss, 47286) #Belt of Biting Cold
          item(boss, 47283) #Belt of Bloodied Scars
          item(boss, 47294) #Bracers of the Broken Bond
          item(boss, 47281) #Bracers of the Silent Massacre
          item(boss, 47288) #Chestplate of the Frostwolf Hero
          item(boss, 47285) #Dual-blade Butcher
          item(boss, 47284) #Icewalker Treads
          item(boss, 47290) #Juggernaut's Vitality
          item(boss, 47289) #Leggings of Concealed Hatred
          item(boss, 47292) #Robes of the Shattered Fellowship
          item(boss, 47295) #Sabatons of Tremoring Earth
          item(boss, 47293) #Sandals of the Mourning Widow
          item(boss, 47291) #Shroud of Displacement
        when "tributechest-10"
          item(boss, 48705) #Attrition
          item(boss, 48699) #Blood and Glory
          item(boss, 48697) #Frenzystrike Longbow
          item(boss, 48693) #Heartsmasher
          item(boss, 48695) #Mor'kosh, the Bloodreaver
          item(boss, 48701) #Spellharvest
          item(boss, 48703) #The Facebreaker
        when "anubarakraid-25-hard"
          item(boss, 47474) #Armbands of Dark Determination
          item(boss, 47476) #Band of the Traitor King
          item(boss, 47485) #Bindings of the Ashen Saint
          item(boss, 47482) #Boots of the Icy Floe
          item(boss, 47478) #Breeches of the Deepening Void
          item(boss, 47486) #Cuirass of Flowing Elements
          item(boss, 47492) #Gauntlets of Bitter Reprisal
          item(boss, 47484) #Girdle of the Forgotten Martyr
          item(boss, 47473) #Greaves of the Saronite Citadel
          item(boss, 47487) #Handwraps of the Lifeless Touch
          item(boss, 47491) #Hellion Glaive
          item(boss, 47475) #Hellscream Slicer
          item(boss, 47479) #Leggings of the Awakening
          item(boss, 47480) #Leggings of the Lurking Threat
          item(boss, 47489) #Lurid Manifestation
          item(boss, 47490) #Maiden's Adoration
          item(boss, 47481) #Might of the Nerub
          item(boss, 47477) #Reign of the Dead
          item(boss, 47483) #Suffering's End
          item(boss, 47472) #Waistguard of Deathly Dominion
        when "northrendbeasts-25"
          item(boss, 47261) #Barb of Tarasque
          item(boss, 47258) #Belt of the Tenebrous Mist
          item(boss, 47265) #Binding of the Ice Burrower
          item(boss, 47253) #Boneshatter Vambraces
          item(boss, 47262) #Boots of the Harsh Winter
          item(boss, 47257) #Cloak of the Untamed Predator
          item(boss, 47251) #Cuirass of Cruel Intent
          item(boss, 47256) #Drape of the Refreshing Winds
          item(boss, 47264) #Flowing Robes of Ascent
          item(boss, 47260) #Forlorn Barrier
          item(boss, 47254) #Hauberk of the Towering Monstrosity
          item(boss, 47259) #Legwraps of the Broken Beast
          item(boss, 47252) #Ring of the Violent Temperament
          item(boss, 47263) #Sabatons of the Courageous
          item(boss, 47255) #Stygian Bladebreaker
        when "jaraxxus-10-hard"
          item(boss, 48008) #Armplates of the Nether Lord
          item(boss, 48002) #Belt of the Bloodhoof Emissary
          item(boss, 48009) #Belt of the Nether Champion
          item(boss, 48005) #Darkspear Ritual Binding
          item(boss, 48000) #Felspark Bracers
          item(boss, 48001) #Firestorm Band
          item(boss, 48011) #Fortitude of the Infernal
          item(boss, 48004) #Legwraps of the Demonic Messenger
          item(boss, 48010) #Orcish Deathblade
          item(boss, 48003) #Pendant of Binding Elements
          item(boss, 48007) #Planestalker Band
          item(boss, 49237) #Sabatons of Tortured Space
          item(boss, 48006) #Warsong Poacher's Greaves
        when "twinvalkyrs-25"
          item(boss, 47298) #Armguards of the Shieldmaiden
          item(boss, 47308) #Belt of Pale Thorns
          item(boss, 47299) #Belt of the Pitiless Killer
          item(boss, 47310) #Chestplate of the Frozen Lake
          item(boss, 47307) #Cry of the Val'kyr
          item(boss, 47306) #Dark Essence Bindings
          item(boss, 47303) #Death's Choice
          item(boss, 47300) #Gouge of the Frigid Heart
          item(boss, 47296) #Greaves of Ruthless Judgment
          item(boss, 47305) #Legionnaire's Gorget
          item(boss, 47304) #Legplates of Ascension
          item(boss, 47309) #Mystifying Charm
          item(boss, 47301) #Skyweaver Vestments
          item(boss, 47297) #The Executioner's Vice
          item(boss, 47302) #Twin's Pact
        when "tributechest-25"
          item(boss, 47528) #Cudgel of the Damned
          item(boss, 47523) #Fezzik's Autocannon
          item(boss, 47516) #Fleshrender
          item(boss, 47520) #Grievance
          item(boss, 47518) #Mortalis
          item(boss, 47513) #Ogrim's Deflector
          item(boss, 47525) #Sufferance
        when "tributechest-10-hard"
          item(boss, 48668) #Cloak of Serrated Blades
          item(boss, 48673) #Cloak of the Silver Covenant
          item(boss, 48669) #Cloak of the Triumphant Combatant
          item(boss, 48670) #Cloak of the Unflinching Guardian
          item(boss, 48675) #Cloak of the Unmoving Guardian
          item(boss, 48674) #Cloak of the Victorious Combatant
          item(boss, 48671) #Drape of Bitter Incantation
          item(boss, 48666) #Drape of the Sunreavers
          item(boss, 48672) #Shawl of Fervent Crusader
          item(boss, 48667) #Shawl of the Devout Crusader
        when "jaraxxus-10"
          item(boss, 47869) #Armplates of the Nether Lord
          item(boss, 47863) #Belt of the Bloodhoof Emissary
          item(boss, 47870) #Belt of the Nether Champion
          item(boss, 47866) #Darkspear Ritual Binding
          item(boss, 47861) #Felspark Bracers
          item(boss, 47862) #Firestorm Band
          item(boss, 47872) #Fortitude of the Infernal
          item(boss, 47865) #Legwraps of the Demonic Messenger
          item(boss, 47871) #Orcish Deathblade
          item(boss, 47864) #Pendant of Binding Elements
          item(boss, 47868) #Planestalker Band
          item(boss, 49236) #Sabatons of Tortured Space
          item(boss, 47867) #Warsong Poacher's Greaves
        end
      end
    end
  end
  
  desc "Populate wishlist data"
  task :wishlist => [:environment] do
    [Boss, LootTable, Zone].each(&:destroy_all)
    
    wotlk_data()
    ulduar_data()
    crusade_data()
  end
end