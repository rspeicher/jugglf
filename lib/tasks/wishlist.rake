require 'wishlist_data'

namespace :juggernaut do
  desc "Populate wishlist data"
  task :wishlist => [:environment] do
    [Boss, LootTable, Zone].each(&:destroy_all)

    # WishlistData::EyeOfEternity
    # WishlistData::ObsidianSanctum
    # WishlistData::Ulduar
    WishlistData::TrialOfTheCrusader
    WishlistData::IcecrownCitadel
    WishlistData::RubySanctum
  end
end
