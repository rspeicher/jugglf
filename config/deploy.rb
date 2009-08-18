set :application, "juggrails"
set :deploy_to,   "/var/www/rails/#{application}"

set :domain,      "lf.juggernautguild.com"
set :repository,  "git@tsigo.com:#{application}.git"
set :scm,         'git'
set :branch,      'master'

set :use_sudo, false
set :keep_releases, 3

set :user, 'tsigo'
set :ssh_options, { :forward_agent => true, :keys => "/Users/tsigo/.ssh/id_rsa" }

role :app, domain
role :web, domain
role :db,  domain, :primary => true

namespace :deploy do
  desc "Start the server"
  task :start, :roles => :app do
    run "rm -f #{current_release}/tmp/stop.txt"
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "Redirect to a 503 file (stop the server)"
  task :stop, :roles => :app do
    run "touch #{current_release}/tmp/stop.txt"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

after "deploy:symlink", "deploy:update_crontab"
after "deploy:symlink", "deploy:database_yml"

namespace :deploy do
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && whenever --update-crontab #{application}"
  end
  
  desc "Copy database.yml file"
  task :database_yml, :roles => :db do
    run "cp #{shared_path}/config/database.yml #{current_release}/config/database.yml"
  end
  
  desc "Run the juggernaut:wishlist rake task"
  task :wishlist do
    run "cd #{release_path} && rake RAILS_ENV=production juggernaut:wishlist"
  end
end