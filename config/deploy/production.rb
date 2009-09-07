set :domain,      "lf.juggernautguild.com"
set :repository,  "git@tsigo.com:#{application}.git"
set :scm,         'git'
set :branch,      'master'

set :deploy_to,   "/var/www/rails/#{application}"

role :app, domain
role :web, domain
role :db,  domain, :primary => true

before "deploy:update", "deploy:check_revision"

namespace :deploy do
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && whenever --update-crontab #{application}"
  end

  desc "Make sure there is something to deploy"
  task :check_revision, :roles => [:web] do
    unless `git rev-parse HEAD` == `git rev-parse production/master`
      puts ""
      puts "  \033[1;33m**************************************************\033[0m"
      puts "  \033[1;33m* WARNING: HEAD is not the same as origin/master *\033[0m"
      puts "  \033[1;33m**************************************************\033[0m"
      puts ""
 
      exit
    end
  end
end

after "deploy:symlink", "deploy:update_crontab"