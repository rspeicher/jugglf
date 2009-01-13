namespace :jugg do
  desc "Update LF Cache"
  task :updatelf => [:environment] do
    Member.update_all_cache
  end
end