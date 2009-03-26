# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

every 1.day, :at => '3:30 am' do
  runner 'Member.update_cache(:all)'
end

every 1.day, :at => '4:00 am' do
  rake 'jugg:achievements'
end

every 20.minutes do
  runner 'Session.delete_all [\'updated_at < ?\', 20.minutes.ago]'
end

# Example:
#
# set :cron_log, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
