namespace :jugg do
  desc "Update LF Cache"
  task :updatelf => [:environment] do
    Member.update_cache(:all)
  end
end