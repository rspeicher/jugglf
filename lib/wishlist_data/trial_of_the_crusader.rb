module WishlistData
  class TrialOfTheCrusader
    include WishlistData

    def initialize
      # TODO: Update to new format
      crusade_data
    end

    def crusade_data
      toc_bosses = {
        # 'Trial of the Crusader (10)' => [
        #   ['northrendbeasts-10'       , 'Northrend Beasts'],
        #   ['jaraxxus-10'              , 'Jaraxxus'],
        #   ['factionchampions-10'      , 'Faction Champions'],
        #   ['twinvalkyrs-10'           , 'Twin Valkyrs'],
        #   ['anubarakraid-10'          , "Anub'arak"]
        # ],
        # 'Trial of the Crusader (25)' => [
        #   ['northrendbeasts-25'       , 'Northrend Beasts'],
        #   ['jaraxxus-25'              , 'Jaraxxus'],
        #   ['factionchampions-25'      , 'Faction Champions'],
        #   ['twinvalkyrs-25'           , 'Twin Valkyrs'],
        #   ['anubarakraid-25'          , "Anub'arak"]
        # ],
        # 'Trial of the Grand Crusader (10H)' => [
        #   ['northrendbeasts-10-hard'  , 'Northrend Beasts'],
        #   ['jaraxxus-10-hard'         , 'Jaraxxus'],
        #   ['factionchampions-10-hard' , 'Faction Champions'],
        #   ['twinvalkyrs-10-hard'      , 'Twin Valkyrs'],
        #   ['anubarakraid-10-hard'     , "Anub'arak"],
        #   ['tributechest-10'          , 'Tribute Chest'],
        # ],
        'Trial of the Grand Crusader (25H)' => [
          ['northrendbeasts-25-hard'  , 'Northrend Beasts'],
          ['jaraxxus-25-hard'         , 'Jaraxxus'],
          ['factionchampions-25-hard' , 'Faction Champions'],
          ['twinvalkyrs-25-hard'      , 'Twin Valkyrs'],
          ['anubarakraid-25-hard'     , "Anub'arak"],
          ['tributechest-25'          , 'Tribute Chest'],
      ]
      }

      toc_bosses.sort.each do |zone_name, bosses|
        zone = zone(zone_name)
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
            item(boss, 47242) #Trophy of the Crusade
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
            item(boss, 47242) #Trophy of the Crusade
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
            item(boss, 47242) #Trophy of the Crusade
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
            item(boss, 47242) #Trophy of the Crusade
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
            item(boss, 47242) #Trophy of the Crusade
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
            item(boss, 47242) #Trophy of the Crusade
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
            item(boss, 47242) #Trophy of the Crusade
          when "tributechest-10"
            item(boss, 48705) #Attrition
            item(boss, 48699) #Blood and Glory
            item(boss, 48668) #Cloak of Serrated Blades
            item(boss, 48669) #Cloak of the Triumphant Combatant
            item(boss, 48670) #Cloak of the Unflinching Guardian
            item(boss, 48666) #Drape of the Sunreavers
            item(boss, 48697) #Frenzystrike Longbow
            item(boss, 48693) #Heartsmasher
            item(boss, 48695) #Mor'kosh, the Bloodreaver
            item(boss, 48667) #Shawl of the Devout Crusader
            item(boss, 48701) #Spellharvest
            item(boss, 48703) #The Facebreaker
            item(boss, 47242) #Trophy of the Crusade
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
            item(boss, 47242) #Trophy of the Crusade
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
            item(boss, 47242) #Trophy of the Crusade
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
            item(boss, 47242) #Trophy of the Crusade
            item(boss, 47302) #Twin's Pact
          when "tributechest-25"
            item(boss, 47551) #Aethas' Intensity
            item(boss, 47550) #Cairne's Endurance
            item(boss, 47528) #Cudgel of the Damned
            item(boss, 47523) #Fezzik's Autocannon
            item(boss, 47516) #Fleshrender
            item(boss, 47548) #Garrosh's Rage
            item(boss, 47520) #Grievance
            item(boss, 47554) #Lady Liadrin's Conviction
            item(boss, 47518) #Mortalis
            item(boss, 47513) #Ogrim's Deflector
            item(boss, 47557) #Regalia of the Grand Conqueror
            item(boss, 47558) #Regalia of the Grand Protector
            item(boss, 47559) #Regalia of the Grand Vanquisher
            item(boss, 47525) #Sufferance
            item(boss, 47546) #Sylvanas' Cunning
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

  end
end
