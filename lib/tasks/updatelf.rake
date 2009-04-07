namespace :jugg do
  desc "Update LF Cache"
  task :updatelf => [:environment] do
    Member.update_cache(:all)
    
    # Surely there's a better way to do this, but whatever.
    FileUtils.rm_rf(Dir['tmp/cache/views/*/index*'])
  end
end