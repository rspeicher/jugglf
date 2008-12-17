namespace :jugg do
  desc "Update LF Cache"
  task :updatelf => [:environment] do
    total = { }
    total[:thirty]   = Raid.count(:conditions => [ "date >= ?", 30.days.ago ]) * 1.00
    total[:ninety]   = Raid.count(:conditions => [ "date >= ?", 90.days.ago ]) * 1.00
    total[:lifetime] = Raid.count * 1.00
    
    Member.all.each do |m|
      # Attendance
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
      
      # Loot Factor
      cutoff = 56.days.ago.to_datetime
      lf = { :lf => 0.00, :sitlf => 0.00, :bislf => 0.00 }
      m.items.each do |i|
        if i.raid.date >= cutoff
          if i.situational?
            lf[:sitlf] += i.price
          elsif i.best_in_slot?
            lf[:bislf] += i.price
          else
            lf[:lf] += i.price
          end
        end
      end
      
      puts "#{lf[:lf]} / #{m.attendance_30}"
      
      m.lf    = (lf[:lf]    / m.attendance_30) unless m.attendance_30 == 0.0
      m.sitlf = (lf[:sitlf] / m.attendance_30) unless m.attendance_30 == 0.0
      m.bislf = (lf[:bislf] / m.attendance_30) unless m.attendance_30 == 0.0
      
      begin
        m.save!
      rescue Exception
        puts "\tError"
      end
    end
  end
end