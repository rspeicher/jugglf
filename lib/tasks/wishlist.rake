namespace :jugg do
  desc "Populate wishlist data"
  task :wishlist => [:environment] do
    [Boss, LootTable, Zone].each(&:destroy_all)
  end
end