require 'vlad'

set :application, "juggrails"
set :user, 'tsigo'
set :domain, "#{user}@gluttony"
set :deploy_to, "/home/tsigo/rails/juggrails2"
set :repository, 'git@gluttony:/juggrails.git'
# set :repository, 'svn+ssh://tsigo@localhost/svn/juggdkp2'
# set :revision, 'master'

namespace :vlad do
  set :app_command, "/etc/init.d/apache2"

  desc 'Restart Passenger'
  remote_task :start_app, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc 'Restarts the apache servers'
  remote_task :start_web, :roles => :app do
    run "sudo #{app_command} restart"
  end
end