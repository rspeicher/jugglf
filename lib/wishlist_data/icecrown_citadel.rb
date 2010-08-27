module WishlistData
  class IcecrownCitadel
    include WishlistData

    def initialize
      # TODO: Update to new format
      icecrown_data

      # %w(icecrown-citadel-10-hard icecrown-citadel-25-hard).each do |zone_tag|
      #   zone = zone(tag_to_name(zone_tag))

      #   tag_suffix = zone_tag.gsub(/((10|25).+)$/, $1)
      # end

      # %w(halion-10 halion-10-hard halion-25 halion-25-hard).each do |boss_tag|
      #   boss = boss(zone, tag_to_name(boss_tag))
      #   populate(boss_tag, boss)
      # end
    end

    def icecrown_data
      icc_bosses = {
        # 'Icecrown Citadel (10)' => [
        #   ['marrowgar-10',     'Lord Marrowgar'],
        #   ['deathwhisper-10',  'Lady Deathwhisper'],
        #   ['gunship-10',       'Gunship Battle'],
        #   ['saurfang-10',      'Deathbringer Saurfang'],

        #   ['festergut-10',     'Festergut'],
        #   ['rotface-10',       "Rotface"],
        #   ['putricide-10',     'Professor Putricide'],

        #   ['bloodprinces-10',  'Blood Prince Council'],
        #   ['queenlanathel-10', "Blood-Queen Lana'thel"],

        #   ['valithria-10',     "Valithria Dreamwalker"],
        #   ['sindragosa-10',    'Sindragosa'],

        #   ['lichking-10',      'The Lich King']
        # ],
        # 'Icecrown Citadel (25)' => [
        #   ['trash-25',         'Trash'],

        #   ['marrowgar-25',     'Lord Marrowgar'],
        #   ['deathwhisper-25',  'Lady Deathwhisper'],
        #   ['gunship-25',       'Gunship Battle'],
        #   ['saurfang-25',      'Deathbringer Saurfang'],

        #   ['festergut-25',     'Festergut'],
        #   ['rotface-25',       "Rotface"],
        #   ['putricide-25',     'Professor Putricide'],

        #   ['bloodprinces-25',  'Blood Prince Council'],
        #   ['queenlanathel-25', "Blood-Queen Lana'thel"],

        #   ['valithria-25',     "Valithria Dreamwalker"],
        #   ['sindragosa-25',    'Sindragosa'],

        #   ['lichking-25',      'The Lich King']
        # ],
        'Icecrown Citadel (10H)' => [
          ['marrowgar-10-hard',     'Lord Marrowgar'],
          ['deathwhisper-10-hard',  'Lady Deathwhisper'],
          ['gunship-10-hard',       'Gunship Battle'],
          ['saurfang-10-hard',      'Deathbringer Saurfang'],

          ['festergut-10-hard',     'Festergut'],
          ['rotface-10-hard',       "Rotface"],
          ['putricide-10-hard',     'Professor Putricide'],

          ['bloodprinces-10-hard',  'Blood Prince Council'],
          ['queenlanathel-10-hard', "Blood-Queen Lana'thel"],

          ['valithria-10-hard',     "Valithria Dreamwalker"],
          ['sindragosa-10-hard',    'Sindragosa'],

          ['lichking-10-hard',      'The Lich King']
      ],
        'Icecrown Citadel (25H)' => [
          ['trash-25-hard',         'Trash'],

          ['marrowgar-25-hard',     'Lord Marrowgar'],
          ['deathwhisper-25-hard',  'Lady Deathwhisper'],
          ['gunship-25-hard',       'Gunship Battle'],
          ['saurfang-25-hard',      'Deathbringer Saurfang'],

          ['festergut-25-hard',     'Festergut'],
          ['rotface-25-hard',       "Rotface"],
          ['putricide-25-hard',     'Professor Putricide'],

          ['bloodprinces-25-hard',  'Blood Prince Council'],
          ['queenlanathel-25-hard', "Blood-Queen Lana'thel"],

          ['valithria-25-hard',     "Valithria Dreamwalker"],
          ['sindragosa-25-hard',    'Sindragosa'],

          ['lichking-25-hard',      'The Lich King']
      ]
      }

      icc_bosses.sort.each do |zone_name, bosses|
        zone = zone(zone_name)
        bosses.each do |boss_tag, boss_name|
          boss = boss(zone, boss_name)
          case boss_tag
          when "queenlanathel-10"
            item(boss, 51384) #Bloodsipper
            item(boss, 51551) #Chestguard of Siphoned Elements
            item(boss, 51548) #Collar of Haughty Disdain
            item(boss, 51554) #Cowl of Malefic Repose
            item(boss, 51550) #Ivory-Inlaid Leggings
            item(boss, 51553) #Lana'thel's Bloody Nail
            item(boss, 51387) #Seal of the Twilight Queen
            item(boss, 51552) #Shoulderpads of the Searing Kiss
            item(boss, 51385) #Stakethrower
            item(boss, 51386) #Throatrender Handguards
            item(boss, 51555) #Tightening Waistband
            item(boss, 51556) #Veincrusher Gauntlets
          when "rotface-10-hard"
            item(boss, 51876) #Abomination Knuckles
            item(boss, 51870) #Chestguard of the Failed Experiment
            item(boss, 51871) #Choker of Filthy Diamonds
            item(boss, 51872) #Ether-Soaked Bracers
            item(boss, 51879) #Flesh-Shaper's Gurney Strap
            item(boss, 51874) #Gloves of Broken Fingers
            item(boss, 51880) #Gluth's Fetching Knife
            item(boss, 51875) #Lockjaw
            item(boss, 51878) #Rotface's Rupturing Ring
            item(boss, 51881) #Shaft of Glacial Ice
            item(boss, 51873) #Shuffling Shoes
            item(boss, 51877) #Taldron's Short-Sighted Helm
          when "gunship-25"
            item(boss, 50359) #Althor's Abacus
            item(boss, 50005) #Amulet of the Silent Eulogy
            item(boss, 50003) #Boneguard Commander's Pauldrons
            item(boss, 50009) #Boots of Unnatural Growth
            item(boss, 50006) #Corp'rethar Ceremonial Crown
            item(boss, 50352) #Corpse Tongue Coin
            item(boss, 50011) #Gunship Captain's Mittens
            item(boss, 50001) #Ikfirus's Sack of Wonder
            item(boss, 50002) #Polar Bear Claw Bracers
            item(boss, 50008) #Ring of Rapid Ascent
            item(boss, 50000) #Scourge Hunter's Vambraces
            item(boss, 50411) #Scourgeborne Waraxe
            item(boss, 49998) #Shadowvault Slayer's Cloak
            item(boss, 49999) #Skeleton Lord's Circle
            item(boss, 50010) #Waistband of Righteous Fury
          when "sindragosa-25"
            item(boss, 52027) #Conqueror's Mark of Sanctification
            item(boss, 50424) #Memory of Malygos
            item(boss, 50360) #Phylactery of the Nameless Lich
            item(boss, 52026) #Protector's Mark of Sanctification
            item(boss, 50421) #Sindragosa's Cruel Claw
            item(boss, 50361) #Sindragosa's Flawless Fang
            item(boss, 50423) #Sundial of Eternal Dusk
            item(boss, 52025) #Vanquisher's Mark of Sanctification
          when "saurfang-25-hard"
            item(boss, 50671) #Belt of the Blood Nova
            item(boss, 50672) #Bloodvenom Blade
            item(boss, 52030) #Conqueror's Mark of Sanctification
            item(boss, 52027) #Conqueror's Mark of Sanctification
            item(boss, 50363) #Deathbringer's Will
            item(boss, 50668) #Greatcloak of the Turned Champion
            item(boss, 52026) #Protector's Mark of Sanctification
            item(boss, 52029) #Protector's Mark of Sanctification
            item(boss, 50670) #Toskk's Maximized Wristguards
            item(boss, 52025) #Vanquisher's Mark of Sanctification
            item(boss, 52028) #Vanquisher's Mark of Sanctification
          when "festergut-10"
            item(boss, 50966) #Abracadaver
            item(boss, 50988) #Bloodstained Surgeon's Shoulderguards
            item(boss, 50859) #Cloak of Many Skins
            item(boss, 50967) #Festergut's Gaseous Gloves
            item(boss, 50811) #Festering Fingerguards
            item(boss, 50810) #Gutbuster
            item(boss, 50990) #Kilt of Untreated Wounds
            item(boss, 50858) #Plague-Soaked Leather Leggings
            item(boss, 50852) #Precious's Putrid Collar
            item(boss, 50986) #Signet of Putrefaction
            item(boss, 50812) #Taldron's Long Neglected Boots
            item(boss, 50985) #Wrists of Septic Shock
          when "putricide-25-hard"
            item(boss, 50707) #Astrylian's Sutured Cinch
            item(boss, 52030) #Conqueror's Mark of Sanctification
            item(boss, 52027) #Conqueror's Mark of Sanctification
            item(boss, 50708) #Last Word
            item(boss, 50705) #Professor's Bloodied Smock
            item(boss, 52029) #Protector's Mark of Sanctification
            item(boss, 52026) #Protector's Mark of Sanctification
            item(boss, 50704) #Rigormortis
            item(boss, 50706) #Tiny Abomination in a Jar
            item(boss, 52025) #Vanquisher's Mark of Sanctification
            item(boss, 52028) #Vanquisher's Mark of Sanctification
          when "lichking-25-hard"
            item(boss, 50731) #Archus, Greatstaff of Antonidas
            item(boss, 50732) #Bloodsurge, Kel'Thuzad's Blade of Agony
            item(boss, 52030) #Conqueror's Mark of Sanctification
            item(boss, 52027) #Conqueror's Mark of Sanctification
            item(boss, 50733) #Fal'inrush, Defender of Quel'thalas
            item(boss, 50730) #Glorenzelg, High-Blade of the Silver Hand
            item(boss, 50737) #Havoc's Call, Blade of Lordaeron Kings
            item(boss, 50736) #Heaven's Fall, Kryss of a Thousand Lies
            item(boss, 50738) #Mithrios, Bronzebeard's Legacy
            item(boss, 50735) #Oathbinder, Charge of the Ranger-General
            item(boss, 52026) #Protector's Mark of Sanctification
            item(boss, 52029) #Protector's Mark of Sanctification
            item(boss, 50734) #Royal Scepter of Terenas II
            item(boss, 52025) #Vanquisher's Mark of Sanctification
            item(boss, 52028) #Vanquisher's Mark of Sanctification
          when "saurfang-10"
            item(boss, 50801) #Blade-Scored Carapace
            item(boss, 50808) #Deathforged Legplates
            item(boss, 50802) #Gargoyle Spit Bracers
            item(boss, 50800) #Hauberk of a Thousand Cuts
            item(boss, 50804) #Icecrown Spire Sandals
            item(boss, 50806) #Leggings of Unrelenting Blood
            item(boss, 50805) #Mag'hari Chieftain's Staff
            item(boss, 50798) #Ramaladni's Blade of Culling
            item(boss, 50803) #Saurfang's Cold-Forged Band
            item(boss, 50799) #Scourge Stranglers
            item(boss, 50809) #Soulcleave Pendant
            item(boss, 50807) #Thaumaturge's Crackling Cowl
          when "putricide-10"
            item(boss, 51017) #Cauterized Cord
            item(boss, 51018) #Chestplate of Septic Stitches
            item(boss, 51013) #Discarded Bag of Entrails
            item(boss, 51011) #Flesh-Carving Scalpel
            item(boss, 51012) #Infected Choker
            item(boss, 51016) #Pendant of Split Veins
            item(boss, 51019) #Rippling Flesh Kilt
            item(boss, 51014) #Scalpel-Sharpening Shoulderguards
            item(boss, 51015) #Shoulderpads of the Morbid Ritual
            item(boss, 51020) #Shoulders of Ruinous Senility
            item(boss, 51010) #The Facelifter
            item(boss, 50341) #Unidentifiable Organ
          when "saurfang-10-hard"
            item(boss, 51902) #Blade-Scored Carapace
            item(boss, 52027) #Conqueror's Mark of Sanctification
            item(boss, 51895) #Deathforged Legplates
            item(boss, 51901) #Gargoyle Spit Bracers
            item(boss, 51903) #Hauberk of a Thousand Cuts
            item(boss, 51899) #Icecrown Spire Sandals
            item(boss, 51897) #Leggings of Unrelenting Blood
            item(boss, 51898) #Mag'hari Chieftain's Staff
            item(boss, 52026) #Protector's Mark of Sanctification
            item(boss, 51905) #Ramaladni's Blade of Culling
            item(boss, 51900) #Saurfang's Cold-Forged Band
            item(boss, 51904) #Scourge Stranglers
            item(boss, 51894) #Soulcleave Pendant
            item(boss, 51896) #Thaumaturge's Crackling Cowl
            item(boss, 52025) #Vanquisher's Mark of Sanctification
          when "bloodprinces-25"
            item(boss, 50175) #Crypt Keeper's Bracers
            item(boss, 49919) #Cryptmaker
            item(boss, 50073) #Geistlord's Punishment Sack
            item(boss, 50174) #Incarnadine Band of Mending
            item(boss, 50184) #Keleseth's Seducer
            item(boss, 50072) #Landsoul's Horned Greathelm
            item(boss, 50177) #Mail of Crimson Coins
            item(boss, 50074) #Royal Crimson Cloak
            item(boss, 50176) #San'layn Ritualist Gloves
            item(boss, 50172) #Sanguine Silk Robes
            item(boss, 50173) #Shadow Silk Spindle
            item(boss, 50171) #Shoulders of Frost-Tipped Thorns
            item(boss, 50075) #Taldaram's Plated Fists
            item(boss, 50071) #Treads of the Wasteland
            item(boss, 50170) #Valanar's Other Signet Ring
          when "gunship-25-hard"
            item(boss, 50366) #Althor's Abacus
            item(boss, 50658) #Amulet of the Silent Eulogy
            item(boss, 50660) #Boneguard Commander's Pauldrons
            item(boss, 50665) #Boots of Unnatural Growth
            item(boss, 50661) #Corp'rethar Ceremonial Crown
            item(boss, 50349) #Corpse Tongue Coin
            item(boss, 50663) #Gunship Captain's Mittens
            item(boss, 50656) #Ikfirus's Sack of Wonder
            item(boss, 50659) #Polar Bear Claw Bracers
            item(boss, 50664) #Ring of Rapid Ascent
            item(boss, 50655) #Scourge Hunter's Vambraces
            item(boss, 50654) #Scourgeborne Waraxe
            item(boss, 50653) #Shadowvault Slayer's Cloak
            item(boss, 50657) #Skeleton Lord's Circle
            item(boss, 50667) #Waistband of Righteous Fury
          when "valithria-25-hard"
            item(boss, 50619) #Anub'ar Stalker's Gloves
            item(boss, 50632) #Boots of the Funeral March
            item(boss, 50630) #Bracers of Eternal Dreaming
            item(boss, 50620) #Coldwraith Links
            item(boss, 50622) #Devium's Eternally Cold Ring
            item(boss, 50628) #Frostbinder's Shredded Cape
            item(boss, 50618) #Frostbrood Sapphire Ring
            item(boss, 50625) #Grinning Skull Greatboots
            item(boss, 50623) #Leggings of Dying Candles
            item(boss, 50621) #Lungbreaker
            item(boss, 50631) #Nightmare Ender
            item(boss, 50627) #Noose of Malachite
            item(boss, 50629) #Robe of the Waking Nightmare
            item(boss, 50624) #Scourge Reaver's Legplates
            item(boss, 50626) #Snowstorm Helm
          when "lichking-10"
            item(boss, 51799) #Halion, Staff of Forgotten Love
            item(boss, 51801) #Pugius, Fist of Defiance
            item(boss, 51800) #Stormfury, Black Blade of the Betrayer
            item(boss, 51797) #Tainted Twig of Nordrassil
            item(boss, 51803) #Tel'thas, Dagger of the Blood King
            item(boss, 51795) #Troggbane, Axe of the Frostborne King
            item(boss, 51798) #Valius, Gavel of the Lightbringer
            item(boss, 51796) #Warmace of Menethil
            item(boss, 51802) #Windrunner's Heartseeker
          when "festergut-25-hard"
            item(boss, 50691) #Belt of Broken Bones
            item(boss, 50692) #Black Bruise
            item(boss, 50689) #Carapace of Forgotten Kings
            item(boss, 50695) #Distant Land
            item(boss, 50701) #Faceplate of the Forgotten
            item(boss, 50690) #Fleshrending Gauntlets
            item(boss, 50697) #Gangrenous Leggings
            item(boss, 50700) #Holiday's Grace
            item(boss, 50698) #Horrific Flesh Epaulets
            item(boss, 50696) #Leather of Stitched Scourge Parts
            item(boss, 50702) #Lingering Illness
            item(boss, 50693) #Might of Blight
            item(boss, 50688) #Nerub'ar Stalker's Cord
            item(boss, 50699) #Plague Scientist's Boots
            item(boss, 50694) #Plaguebringer's Stained Pants
            item(boss, 50703) #Unclean Surgical Gloves
          when "queenlanathel-25-hard"
            item(boss, 50726) #Bauble of True Blood
            item(boss, 50724) #Blood Queen's Crimson Choker
            item(boss, 50727) #Bloodfall
            item(boss, 52030) #Conqueror's Mark of Sanctification
            item(boss, 52027) #Conqueror's Mark of Sanctification
            item(boss, 50725) #Dying Light
            item(boss, 50729) #Icecrown Glacial Wall
            item(boss, 50728) #Lana'thel's Chain of Flagellation
            item(boss, 52026) #Protector's Mark of Sanctification
            item(boss, 52029) #Protector's Mark of Sanctification
            item(boss, 52025) #Vanquisher's Mark of Sanctification
            item(boss, 52028) #Vanquisher's Mark of Sanctification
          when "deathwhisper-25"
            item(boss, 49989) #Ahn'kahar Onyx Neckguard
            item(boss, 49983) #Blood-Soaked Saronite Stompers
            item(boss, 49986) #Broken Ram Skull Helm
            item(boss, 49987) #Cultist's Bloodsoaked Spaulders
            item(boss, 49996) #Deathwhisper Chestpiece
            item(boss, 49995) #Fallen Lord's Handguards
            item(boss, 49982) #Heartpierce
            item(boss, 49985) #Juggernaut Band
            item(boss, 49988) #Leggings of Northern Lights
            item(boss, 49993) #Necrophotic Greaves
            item(boss, 49992) #Nibelung
            item(boss, 49990) #Ring of Maddening Whispers
            item(boss, 49991) #Shoulders of Mercy Killing
            item(boss, 49994) #The Lady's Brittle Bracers
            item(boss, 50034) #Zod's Repeating Longbow
          when "valithria-25"
            item(boss, 50188) #Anub'ar Stalker's Gloves
            item(boss, 50416) #Boots of the Funeral March
            item(boss, 50417) #Bracers of Eternal Dreaming
            item(boss, 50187) #Coldwraith Links
            item(boss, 50185) #Devium's Eternally Cold Ring
            item(boss, 50205) #Frostbinder's Shredded Cape
            item(boss, 50186) #Frostbrood Sapphire Ring
            item(boss, 50190) #Grinning Skull Greatboots
            item(boss, 50199) #Leggings of Dying Candles
            item(boss, 50183) #Lungbreaker
            item(boss, 50472) #Nightmare Ender
            item(boss, 50195) #Noose of Malachite
            item(boss, 50418) #Robe of the Waking Nightmare
            item(boss, 50192) #Scourge Reaver's Legplates
            item(boss, 50202) #Snowstorm Helm
          when "deathwhisper-25-hard"
            item(boss, 50647) #Ahn'kahar Onyx Neckguard
            item(boss, 50639) #Blood-Soaked Saronite Stompers
            item(boss, 50640) #Broken Ram Skull Helm
            item(boss, 50646) #Cultist's Bloodsoaked Spaulders
            item(boss, 50649) #Deathwhisper Chestpiece
            item(boss, 50650) #Fallen Lord's Handguards
            item(boss, 50641) #Heartpierce
            item(boss, 50642) #Juggernaut Band
            item(boss, 50645) #Leggings of Northern Lights
            item(boss, 50652) #Necrophotic Greaves
            item(boss, 50648) #Nibelung
            item(boss, 50644) #Ring of Maddening Whispers
            item(boss, 50643) #Shoulders of Mercy Killing
            item(boss, 50651) #The Lady's Brittle Bracers
            item(boss, 50638) #Zod's Repeating Longbow
          when "bloodprinces-25-hard"
            item(boss, 50721) #Crypt Keeper's Bracers
            item(boss, 50603) #Cryptmaker
            item(boss, 50713) #Geistlord's Punishment Sack
            item(boss, 50720) #Incarnadine Band of Mending
            item(boss, 50710) #Keleseth's Seducer
            item(boss, 50712) #Landsoul's Horned Greathelm
            item(boss, 50723) #Mail of Crimson Coins
            item(boss, 50718) #Royal Crimson Cloak
            item(boss, 50722) #San'layn Ritualist Gloves
            item(boss, 50717) #Sanguine Silk Robes
            item(boss, 50719) #Shadow Silk Spindle
            item(boss, 50715) #Shoulders of Frost-Tipped Thorns
            item(boss, 50716) #Taldaram's Plated Fists
            item(boss, 50711) #Treads of the Wasteland
            item(boss, 50714) #Valanar's Other Signet Ring
          when "marrowgar-10"
            item(boss, 50772) #Ancient Skeletal Boots
            item(boss, 50759) #Bone Warden's Splitter
            item(boss, 50760) #Bonebreaker Scepter
            item(boss, 50761) #Citadel Enforcer's Claymore
            item(boss, 50774) #Coldwraith Bracers
            item(boss, 50773) #Cord of the Patronizing Practitioner
            item(boss, 50775) #Corrupted Silverplate Leggings
            item(boss, 50771) #Frost Needle
            item(boss, 50762) #Linked Scourge Vertebrae
            item(boss, 50763) #Marrowgar's Scratching Choker
            item(boss, 50764) #Shawl of Nerubian Silk
            item(boss, 50339) #Sliver of Pure Ice
          when "putricide-10-hard"
            item(boss, 51862) #Cauterized Cord
            item(boss, 51861) #Chestplate of Septic Stitches
            item(boss, 52027) #Conqueror's Mark of Sanctification
            item(boss, 51866) #Discarded Bag of Entrails
            item(boss, 51868) #Flesh-Carving Scalpel
            item(boss, 51867) #Infected Choker
            item(boss, 51863) #Pendant of Split Veins
            item(boss, 52026) #Protector's Mark of Sanctification
            item(boss, 51860) #Rippling Flesh Kilt
            item(boss, 51865) #Scalpel-Sharpening Shoulderguards
            item(boss, 51864) #Shoulderpads of the Morbid Ritual
            item(boss, 51859) #Shoulders of Ruinous Senility
            item(boss, 51869) #The Facelifter
            item(boss, 50344) #Unidentifiable Organ
            item(boss, 52025) #Vanquisher's Mark of Sanctification
          when "queenlanathel-10-hard"
            item(boss, 51846) #Bloodsipper
            item(boss, 51840) #Chestguard of Siphoned Elements
            item(boss, 51842) #Collar of Haughty Disdain
            item(boss, 52027) #Conqueror's Mark of Sanctification
            item(boss, 51837) #Cowl of Malefic Repose
            item(boss, 51841) #Ivory-Inlaid Leggings
            item(boss, 51838) #Lana'thel's Bloody Nail
            item(boss, 52026) #Protector's Mark of Sanctification
            item(boss, 51843) #Seal of the Twilight Queen
            item(boss, 51839) #Shoulderpads of the Searing Kiss
            item(boss, 51845) #Stakethrower
            item(boss, 51844) #Throatrender Handguards
            item(boss, 51836) #Tightening Waistband
            item(boss, 52025) #Vanquisher's Mark of Sanctification
            item(boss, 51835) #Veincrusher Gauntlets
          when "festergut-25"
            item(boss, 50036) #Belt of Broken Bones
            item(boss, 50035) #Black Bruise
            item(boss, 50038) #Carapace of Forgotten Kings
            item(boss, 50040) #Distant Land
            item(boss, 50060) #Faceplate of the Forgotten
            item(boss, 50037) #Fleshrending Gauntlets
            item(boss, 50042) #Gangrenous Leggings
            item(boss, 50061) #Holiday's Grace
            item(boss, 50059) #Horrific Flesh Epaulets
            item(boss, 50041) #Leather of Stitched Scourge Parts
            item(boss, 50063) #Lingering Illness
            item(boss, 50414) #Might of Blight
            item(boss, 50413) #Nerub'ar Stalker's Cord
            item(boss, 50062) #Plague Scientist's Boots
            item(boss, 50056) #Plaguebringer's Stained Pants
            item(boss, 50064) #Unclean Surgical Gloves
          when "queenlanathel-25"
            item(boss, 50354) #Bauble of True Blood
            item(boss, 50182) #Blood Queen's Crimson Choker
            item(boss, 50178) #Bloodfall
            item(boss, 52027) #Conqueror's Mark of Sanctification
            item(boss, 50181) #Dying Light
            item(boss, 50065) #Icecrown Glacial Wall
            item(boss, 50180) #Lana'thel's Chain of Flagellation
            item(boss, 52026) #Protector's Mark of Sanctification
            item(boss, 52025) #Vanquisher's Mark of Sanctification
          when "sindragosa-25-hard"
            item(boss, 52027) #Conqueror's Mark of Sanctification
            item(boss, 52030) #Conqueror's Mark of Sanctification
            item(boss, 50636) #Memory of Malygos
            item(boss, 50365) #Phylactery of the Nameless Lich
            item(boss, 52026) #Protector's Mark of Sanctification
            item(boss, 52029) #Protector's Mark of Sanctification
            item(boss, 50633) #Sindragosa's Cruel Claw
            item(boss, 50364) #Sindragosa's Flawless Fang
            item(boss, 50635) #Sundial of Eternal Dusk
            item(boss, 52025) #Vanquisher's Mark of Sanctification
            item(boss, 52028) #Vanquisher's Mark of Sanctification
          when "rotface-10"
            item(boss, 51003) #Abomination Knuckles
            item(boss, 51009) #Chestguard of the Failed Experiment
            item(boss, 51008) #Choker of Filthy Diamonds
            item(boss, 51007) #Ether-Soaked Bracers
            item(boss, 51000) #Flesh-Shaper's Gurney Strap
            item(boss, 51005) #Gloves of Broken Fingers
            item(boss, 50999) #Gluth's Fetching Knife
            item(boss, 51004) #Lockjaw
            item(boss, 51001) #Rotface's Rupturing Ring
            item(boss, 50998) #Shaft of Glacial Ice
            item(boss, 51006) #Shuffling Shoes
            item(boss, 51002) #Taldron's Short-Sighted Helm
          when "deathwhisper-10-hard"
            item(boss, 51920) #Boots of the Frozen Seed
            item(boss, 51918) #Bracers of Dark Blessings
            item(boss, 51923) #Chestguard of the Frigid Noose
            item(boss, 51919) #Deathspeaker Disciple's Belt
            item(boss, 51924) #Deathspeaker Zealot's Helm
            item(boss, 51917) #Ghoul Commander's Cuirass
            item(boss, 51926) #Handgrips of Frost and Sleet
            item(boss, 51927) #Njordnar Bone Bow
            item(boss, 51922) #Scourgelord's Baton
            item(boss, 51921) #Sister's Handshrouds
            item(boss, 51925) #Soulthief's Braided Belt
            item(boss, 50343) #Whispering Fanged Skull
          when "bloodprinces-10-hard"
            item(boss, 51854) #Battle-Maiden's Legguards
            item(boss, 51853) #Blood-Drinker's Girdle
            item(boss, 51851) #Bloodsoul Raiment
            item(boss, 51849) #Cerise Coiled Ring
            item(boss, 51848) #Heartsick Mender's Cape
            item(boss, 51857) #Hersir's Greatspear
            item(boss, 51850) #Pale Corpse Boots
            item(boss, 51858) #Soulbreaker
            item(boss, 51847) #Spaulders of the Blood Princes
            item(boss, 51856) #Taldaram's Soft Slippers
            item(boss, 51855) #Thrice Fanged Signet
            item(boss, 51852) #Wand of Ruby Claret
          when "valithria-10-hard"
            item(boss, 51834) #Dreamhunter's Carbine
            item(boss, 51824) #Emerald Saint's Spaulders
            item(boss, 51831) #Ironrope Belt of Ymirjar
            item(boss, 51823) #Leggings of the Refracted Mind
            item(boss, 51829) #Legguards of the Twisted Dream
            item(boss, 51826) #Lich Wrappings
            item(boss, 51833) #Oxheart
            item(boss, 51828) #Sister Svalna's Aether Staff
            item(boss, 51825) #Sister Svalna's Spangenhelm
            item(boss, 51830) #Skinned Whelp Shoulders
            item(boss, 51827) #Stormbringer Gloves
            item(boss, 51832) #Taiga Bindings
          when "saurfang-25"
            item(boss, 50015) #Belt of the Blood Nova
            item(boss, 50412) #Bloodvenom Blade
            item(boss, 52027) #Conqueror's Mark of Sanctification
            item(boss, 50362) #Deathbringer's Will
            item(boss, 50014) #Greatcloak of the Turned Champion
            item(boss, 52026) #Protector's Mark of Sanctification
            item(boss, 50333) #Toskk's Maximized Wristguards
            item(boss, 52025) #Vanquisher's Mark of Sanctification
          when "marrowgar-25-hard"
            item(boss, 50604) #Band of the Bone Colossus
            item(boss, 50609) #Bone Sentinel's Amulet
            item(boss, 50611) #Bracers of Dark Reckoning
            item(boss, 50709) #Bryntroll, the Bone Arbiter
            item(boss, 50616) #Bulwark of Smouldering Steel
            item(boss, 50613) #Crushing Coldwraith Belt
            item(boss, 50607) #Frostbitten Fur Boots
            item(boss, 50608) #Frozen Bonespike
            item(boss, 50606) #Gendarme's Cuirass
            item(boss, 50615) #Handguards of Winter's Respite
            item(boss, 50612) #Legguards of Lost Hope
            item(boss, 50614) #Loop of the Endless Labyrinth
            item(boss, 50610) #Marrowgar's Frigid Eye
            item(boss, 50617) #Rusted Bonespike Pauldrons
            item(boss, 50605) #Snowserpent Mail Helm
          when "gunship-10"
            item(boss, 50790) #Abomination's Bloody Ring
            item(boss, 50788) #Bone Drake's Enameled Boots
            item(boss, 50796) #Bracers of Pale Illumination
            item(boss, 50795) #Cord of Dark Suffering
            item(boss, 50787) #Frost Giant's Cleaver
            item(boss, 50797) #Ice-Reinforced Vrykul Helm
            item(boss, 50789) #Icecrown Rampart Bracers
            item(boss, 50793) #Midnight Sun
            item(boss, 50340) #Muradin's Spyglass
            item(boss, 50794) #Neverending Winter
            item(boss, 50792) #Pauldrons of Lost Hope
            item(boss, 50791) #Saronite Gargoyle Cloak
          when "sindragosa-10"
            item(boss, 51788) #Bleak Coldarra Carver
            item(boss, 51782) #Etched Dragonbone Girdle
            item(boss, 51789) #Icicle Shapers
            item(boss, 51786) #Legplates of Aetheric Strife
            item(boss, 51791) #Lost Pavise of the Blue Flight
            item(boss, 51779) #Rimetooth Pendant
            item(boss, 51790) #Robes of Azure Downfall
            item(boss, 51787) #Scourge Fanged Stompers
            item(boss, 51792) #Shoulderguards of Crystalline Bone
            item(boss, 51784) #Splintershard
            item(boss, 51783) #Vambraces of the Frost Wyrm Queen
            item(boss, 51785) #Wyrmwing Treads
          when "putricide-25"
            item(boss, 50067) #Astrylian's Sutured Cinch
            item(boss, 52027) #Conqueror's Mark of Sanctification
            item(boss, 50179) #Last Word
            item(boss, 50069) #Professor's Bloodied Smock
            item(boss, 52026) #Protector's Mark of Sanctification
            item(boss, 50068) #Rigormortis
            item(boss, 50351) #Tiny Abomination in a Jar
            item(boss, 52025) #Vanquisher's Mark of Sanctification
          when "lichking-25"
            item(boss, 50429) #Archus, Greatstaff of Antonidas
            item(boss, 50427) #Bloodsurge, Kel'Thuzad's Blade of Agony
            item(boss, 52027) #Conqueror's Mark of Sanctification
            item(boss, 49981) #Fal'inrush, Defender of Quel'thalas
            item(boss, 50070) #Glorenzelg, High-Blade of the Silver Hand
            item(boss, 50012) #Havoc's Call, Blade of Lordaeron Kings
            item(boss, 50426) #Heaven's Fall, Kryss of a Thousand Lies
            item(boss, 49997) #Mithrios, Bronzebeard's Legacy
            item(boss, 50425) #Oathbinder, Charge of the Ranger-General
            item(boss, 52026) #Protector's Mark of Sanctification
            item(boss, 50428) #Royal Scepter of Terenas II
            item(boss, 52025) #Vanquisher's Mark of Sanctification
          when "bloodprinces-10"
            item(boss, 51025) #Battle-Maiden's Legguards
            item(boss, 51325) #Blood-Drinker's Girdle
            item(boss, 51379) #Bloodsoul Raiment
            item(boss, 51381) #Cerise Coiled Ring
            item(boss, 51382) #Heartsick Mender's Cape
            item(boss, 51022) #Hersir's Greatspear
            item(boss, 51380) #Pale Corpse Boots
            item(boss, 51021) #Soulbreaker
            item(boss, 51383) #Spaulders of the Blood Princes
            item(boss, 51023) #Taldaram's Soft Slippers
            item(boss, 51024) #Thrice Fanged Signet
            item(boss, 51326) #Wand of Ruby Claret
          when "gunship-10-hard"
            item(boss, 51913) #Abomination's Bloody Ring
            item(boss, 51915) #Bone Drake's Enameled Boots
            item(boss, 51907) #Bracers of Pale Illumination
            item(boss, 51908) #Cord of Dark Suffering
            item(boss, 51916) #Frost Giant's Cleaver
            item(boss, 51906) #Ice-Reinforced Vrykul Helm
            item(boss, 51914) #Icecrown Rampart Bracers
            item(boss, 51910) #Midnight Sun
            item(boss, 50345) #Muradin's Spyglass
            item(boss, 51909) #Neverending Winter
            item(boss, 51911) #Pauldrons of Lost Hope
            item(boss, 51912) #Saronite Gargoyle Cloak
          when "rotface-25-hard"
            item(boss, 50675) #Aldriana's Gloves of Secrecy
            item(boss, 50682) #Bile-Encrusted Medallion
            item(boss, 50681) #Blightborne Warplate
            item(boss, 50687) #Bloodsunder's Bracers
            item(boss, 50684) #Corpse-Impaling Spike
            item(boss, 50686) #Death Surgeon's Sleeves
            item(boss, 50348) #Dislodged Foreign Object
            item(boss, 50673) #Dual-Bladed Pauldrons
            item(boss, 50679) #Helm of the Elder Moon
            item(boss, 50674) #Raging Behemoth's Shoulderplates
            item(boss, 50676) #Rib Spreader
            item(boss, 50680) #Rot-Resistant Breastplate
            item(boss, 50678) #Seal of Many Mouths
            item(boss, 50685) #Trauma
            item(boss, 50677) #Winding Sheet
          when "festergut-10-hard"
            item(boss, 51887) #Abracadaver
            item(boss, 51883) #Bloodstained Surgeon's Shoulderguards
            item(boss, 51888) #Cloak of Many Skins
            item(boss, 51886) #Festergut's Gaseous Gloves
            item(boss, 51892) #Festering Fingerguards
            item(boss, 51893) #Gutbuster
            item(boss, 51882) #Kilt of Untreated Wounds
            item(boss, 51889) #Plague-Soaked Leather Leggings
            item(boss, 51890) #Precious's Putrid Collar
            item(boss, 51884) #Signet of Putrefaction
            item(boss, 51891) #Taldron's Long Neglected Boots
            item(boss, 51885) #Wrists of Septic Shock
          when "sindragosa-10-hard"
            item(boss, 51815) #Bleak Coldarra Carver
            item(boss, 52027) #Conqueror's Mark of Sanctification
            item(boss, 51821) #Etched Dragonbone Girdle
            item(boss, 51814) #Icicle Shapers
            item(boss, 51817) #Legplates of Aetheric Strife
            item(boss, 51812) #Lost Pavise of the Blue Flight
            item(boss, 52026) #Protector's Mark of Sanctification
            item(boss, 51822) #Rimetooth Pendant
            item(boss, 51813) #Robes of Azure Downfall
            item(boss, 51816) #Scourge Fanged Stompers
            item(boss, 51811) #Shoulderguards of Crystalline Bone
            item(boss, 51819) #Splintershard
            item(boss, 51820) #Vambraces of the Frost Wyrm Queen
            item(boss, 52025) #Vanquisher's Mark of Sanctification
            item(boss, 51818) #Wyrmwing Treads
          when "lichking-10-hard"
            item(boss, 52027) #Conqueror's Mark of Sanctification
            item(boss, 51943) #Halion, Staff of Forgotten Love
            item(boss, 52026) #Protector's Mark of Sanctification
            item(boss, 51941) #Pugius, Fist of Defiance
            item(boss, 51942) #Stormfury, Black Blade of the Betrayer
            item(boss, 51945) #Tainted Twig of Nordrassil
            item(boss, 51939) #Tel'thas, Dagger of the Blood King
            item(boss, 51947) #Troggbane, Axe of the Frostborne King
            item(boss, 51944) #Valius, Gavel of the Lightbringer
            item(boss, 52025) #Vanquisher's Mark of Sanctification
            item(boss, 51946) #Warmace of Menethil
            item(boss, 51940) #Windrunner's Heartseeker
          when "marrowgar-25"
            item(boss, 49949) #Band of the Bone Colossus
            item(boss, 49975) #Bone Sentinel's Amulet
            item(boss, 49960) #Bracers of Dark Reckoning
            item(boss, 50415) #Bryntroll, the Bone Arbiter
            item(boss, 49976) #Bulwark of Smouldering Steel
            item(boss, 49978) #Crushing Coldwraith Belt
            item(boss, 49950) #Frostbitten Fur Boots
            item(boss, 49968) #Frozen Bonespike
            item(boss, 49951) #Gendarme's Cuirass
            item(boss, 49979) #Handguards of Winter's Respite
            item(boss, 49964) #Legguards of Lost Hope
            item(boss, 49977) #Loop of the Endless Labyrinth
            item(boss, 49967) #Marrowgar's Frigid Eye
            item(boss, 49980) #Rusted Bonespike Pauldrons
            item(boss, 49952) #Snowserpent Mail Helm
          when "deathwhisper-10"
            item(boss, 50783) #Boots of the Frozen Seed
            item(boss, 50785) #Bracers of Dark Blessings
            item(boss, 50780) #Chestguard of the Frigid Noose
            item(boss, 50784) #Deathspeaker Disciple's Belt
            item(boss, 50779) #Deathspeaker Zealot's Helm
            item(boss, 50786) #Ghoul Commander's Cuirass
            item(boss, 50777) #Handgrips of Frost and Sleet
            item(boss, 50776) #Njordnar Bone Bow
            item(boss, 50781) #Scourgelord's Baton
            item(boss, 50782) #Sister's Handshrouds
            item(boss, 50778) #Soulthief's Braided Belt
            item(boss, 50342) #Whispering Fanged Skull
          when "valithria-10"
            item(boss, 51561) #Dreamhunter's Carbine
            item(boss, 51586) #Emerald Saint's Spaulders
            item(boss, 51564) #Ironrope Belt of Ymirjar
            item(boss, 51777) #Leggings of the Refracted Mind
            item(boss, 51566) #Legguards of the Twisted Dream
            item(boss, 51584) #Lich Wrappings
            item(boss, 51562) #Oxheart
            item(boss, 51582) #Sister Svalna's Aether Staff
            item(boss, 51585) #Sister Svalna's Spangenhelm
            item(boss, 51565) #Skinned Whelp Shoulders
            item(boss, 51583) #Stormbringer Gloves
            item(boss, 51563) #Taiga Bindings
          when "marrowgar-10-hard"
            item(boss, 51931) #Ancient Skeletal Boots
            item(boss, 51938) #Bone Warden's Splitter
            item(boss, 51937) #Bonebreaker Scepter
            item(boss, 51936) #Citadel Enforcer's Claymore
            item(boss, 51929) #Coldwraith Bracers
            item(boss, 51930) #Cord of the Patronizing Practitioner
            item(boss, 51928) #Corrupted Silverplate Leggings
            item(boss, 51932) #Frost Needle
            item(boss, 51935) #Linked Scourge Vertebrae
            item(boss, 51934) #Marrowgar's Scratching Choker
            item(boss, 51933) #Shawl of Nerubian Silk
            item(boss, 50346) #Sliver of Pure Ice
          when "rotface-25"
            item(boss, 50021) #Aldriana's Gloves of Secrecy
            item(boss, 50023) #Bile-Encrusted Medallion
            item(boss, 50024) #Blightborne Warplate
            item(boss, 50030) #Bloodsunder's Bracers
            item(boss, 50033) #Corpse-Impaling Spike
            item(boss, 50032) #Death Surgeon's Sleeves
            item(boss, 50353) #Dislodged Foreign Object
            item(boss, 50022) #Dual-Bladed Pauldrons
            item(boss, 50026) #Helm of the Elder Moon
            item(boss, 50020) #Raging Behemoth's Shoulderplates
            item(boss, 50016) #Rib Spreader
            item(boss, 50027) #Rot-Resistant Breastplate
            item(boss, 50025) #Seal of Many Mouths
            item(boss, 50028) #Trauma
            item(boss, 50019) #Winding Sheet
          end
        end
      end
    end
  end
end
