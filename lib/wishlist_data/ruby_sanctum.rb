module WishlistData
  class RubySanctum
    include WishlistData

    def initialize
      zone = zone('Ruby Sanctum')

      %w(halion-10 halion-10-hard halion-25 halion-25-hard).each do |boss_tag|
        boss = boss(zone, tag_to_name(boss_tag))
        populate(boss_tag, boss)
      end
    end

    def populate(boss_tag, boss)
      case boss_tag
      when "halion-10-hard"
        item(boss, 54556) #Abduction's Cover
        item(boss, 54557) #Baltharus' Gift
        item(boss, 54558) #Boots of Divided Being
        item(boss, 54559) #Bracers of the Heir
        item(boss, 54560) #Changeling Gloves
        item(boss, 54561) #Gloaming Sark
        item(boss, 54562) #Misbegotten Belt
        item(boss, 54563) #Saviana's Tribute
        item(boss, 54564) #Scion's Treads
        item(boss, 54565) #Surrogate Belt
        item(boss, 54566) #Twilight Scale Shoulders
        item(boss, 54567) #Zarithrian's Offering
      when "halion-10"
        item(boss, 53115) #Abduction's Cover
        item(boss, 53103) #Baltharus' Gift
        item(boss, 53119) #Boots of Divided Being
        item(boss, 53112) #Bracers of the Heir
        item(boss, 53117) #Changeling Gloves
        item(boss, 53114) #Gloaming Sark
        item(boss, 53118) #Misbegotten Belt
        item(boss, 53116) #Saviana's Tribute
        item(boss, 53111) #Scion's Treads
        item(boss, 53121) #Surrogate Belt
        item(boss, 53113) #Twilight Scale Shoulders
        item(boss, 53110) #Zarithrian's Offering
      when "halion-25"
        item(boss, 53125) #Apocalypse's Advance
        item(boss, 53486) #Bracers of Fiery Night
        item(boss, 54572) #Charred Twilight Scale
        item(boss, 53489) #Cloak of Burning Dusk
        item(boss, 53487) #Foreshadow Steps
        item(boss, 54573) #Glowing Twilight Scale
        item(boss, 53132) #Penumbra Pendant
        item(boss, 54571) #Petrified Twilight Scale
        item(boss, 53134) #Phaseshifter's Bracers
        item(boss, 53127) #Returning Footfalls
        item(boss, 53490) #Ring of Phased Regeneration
        item(boss, 54569) #Sharpened Twilight Scale
        item(boss, 53133) #Signet of Twilight
        item(boss, 53488) #Split Shape Belt
        item(boss, 53129) #Treads of Impending Resurrection
        item(boss, 53126) #Umbrage Armbands
      when "halion-25-hard"
        item(boss, 54578) #Apocalypse's Advance
        item(boss, 54582) #Bracers of Fiery Night
        item(boss, 54588) #Charred Twilight Scale
        item(boss, 54583) #Cloak of Burning Dusk
        item(boss, 54586) #Foreshadow Steps
        item(boss, 54589) #Glowing Twilight Scale
        item(boss, 54581) #Penumbra Pendant
        item(boss, 54591) #Petrified Twilight Scale
        item(boss, 54584) #Phaseshifter's Bracers
        item(boss, 54577) #Returning Footfalls
        item(boss, 54585) #Ring of Phased Regeneration
        item(boss, 54590) #Sharpened Twilight Scale
        item(boss, 54576) #Signet of Twilight
        item(boss, 54587) #Split Shape Belt
        item(boss, 54579) #Treads of Impending Resurrection
        item(boss, 54580) #Umbrage Armbands
      end
    end
  end
end
