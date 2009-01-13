namespace :jugg do
  desc "Update LF Cache"
  task :updatelf => [:environment] do
    Member.all.each do |m|
      m.force_recache!
    end
  end
end