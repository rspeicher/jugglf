namespace :jugg do
  desc "Update LF Cache"
  task :updatelf => [:environment] do
    total = { }
    total[:thirty]   = Raid.count(:conditions => [ "date >= ?", 30.days.ago ]) * 1.00
    total[:ninety]   = Raid.count(:conditions => [ "date >= ?", 90.days.ago ]) * 1.00
    total[:lifetime] = Raid.count * 1.00
    
    Member.all.each do |m|
      att = { :thirty => 0.00, :ninety => 0.00, :lifetime => 0.00 }
      m.attendees.each do |a|
        if a.raid.date >= 30.days.ago.to_datetime
          att[:thirty] += a.attendance
        end
        
        if a.raid.date >= 90.days.ago.to_datetime
          att[:ninety] += a.attendance
        end
        
        att[:lifetime] += a.attendance
      end
      
      m.attendance_30       = (att[:thirty] / total[:thirty]) or 0.00
      m.attendance_90       = (att[:ninety] / total[:ninety]) or 0.00
      m.attendance_lifetime = (att[:lifetime] / total[:lifetime]) or 0.00
      m.save!
    end
  end
end