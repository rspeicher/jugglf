class AttendanceObserver < ActiveRecord::Observer
  observe :raid

  # Deletes a corresponding LiveRaid record when a Raid of the same date is
  # created; keeps our attendance interface a bit cleaner
  def after_create(raid)
    LiveRaid.where('started_at >= ?', raid.date).each do |live_raid|
      live_raid.destroy if live_raid.started_at.to_date == raid.date
    end
  end
end
