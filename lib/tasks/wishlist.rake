require 'wishlist_data'

namespace :juggernaut do
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

  desc "Populate wishlist data"
  task :wishlist => [:environment] do
    [Boss, LootTable, Zone].each(&:destroy_all)

    WishlistData::TrialOfTheCrusader.new
    WishlistData::IcecrownCitadel.new
    WishlistData::RubySanctum.new
  end
end
