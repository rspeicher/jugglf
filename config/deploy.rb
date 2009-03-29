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
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
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
end

# -----------------------------------------------------------------------------

# set :application, "juggrails"
# set :server_name, "lootfactor.com"
# set :repository, "git://gluttony/#{application}.git"
# set :scm, "git"
# # set :checkout, "export"
# # set :deploy_via, :remote_cache
# # set :branch, "master"
# 
# set :base_path, "/var/www"
# set :deploy_to, "#{base_path}/#{application}"
# set :apache_site_folder, "/etc/apache2/sites-enabled"
# set :user, 'deploy'
# set :runner, 'deploy'
# set :use_sudo, true
# set :keep_releases, 3 
# 
# role :web, server_name
# role :app, server_name
# role :db,  server_name, :primary => true
# 
# ssh_options[:paranoid] = false
# default_run_options[:pty] = true
# 
# after "deploy:setup", "init:set_permissions"
# after "deploy:setup", "init:database_yml"
# after "deploy:update_code", "config:copy_shared_configurations"
# 
# # Overrides for Phusion Passenger
# namespace :deploy do
#   desc "Restarting mod_rails with restart.txt"
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "touch #{current_path}/tmp/restart.txt"
#   end
# 
#   [:start, :stop].each do |t|
#     desc "#{t} task is a no-op with mod_rails"
#     task t, :roles => :app do ; end
#   end
# end
# 
# # Configuration Tasks
# namespace :config do
#   desc "copy shared configurations to current"
#   task :copy_shared_configurations, :roles => [:app] do
#     %w[database.yml].each do |f|
#       run "ln -nsf #{shared_path}/config/#{f} #{release_path}/config/#{f}"
#     end
#   end
# end
# 
# namespace :init do
# 
#   desc "setting proper permissions for deploy user"
#   task :set_permissions do
#     sudo "chown -R deploy #{base_path}/#{application}"
#   end
# 
#   desc "create mysql db"
#   task :create_database do
#     #create the database on setup
#     set :db_user, Capistrano::CLI.ui.ask("database user: ")# unless defined?(:db_user)
#     set :db_pass, Capistrano::CLI.password_prompt("database password: ")# unless defined?(:db_pass)
#     run "mysqladmin -u #{db_user} --password=#{db_pass} create #{application}_production"
#   end
# 
#   desc "enable site"
#   task :enable_site do
#     sudo "ln -nsf #{shared_path}/config/apache_site.conf #{apache_site_folder}/#{application}"
# 
#   end
# 
#   desc "create database.yml"
#   task :database_yml do
#     set :db_user, Capistrano::CLI.ui.ask("database user: ")
#     set :db_pass, Capistrano::CLI.password_prompt("database password: ")
#     database_configuration = %(
# —
# login: &login
#   adapter: mysql
#   encoding: utf8
#   database: #{application}_production
#   host: localhost
#   username: #{db_user}
#   password: #{db_pass}
#   socket: /var/run/mysqld/mysqld.sock
# 
# production:
#   <<: *login
# )
#     run "mkdir -p #{shared_path}/config"
#     put database_configuration, "#{shared_path}/config/database.yml"
#   end
# 
#   desc "create vhost file"
#   task :create_vhost do
# 
#     vhost_configuration = %(
# 
#   ServerName #{server_name}
#   DocumentRoot #{base_path}/#{application}/current/public
# 
# )
# 
#     put vhost_configuration, "#{shared_path}/config/apache_site.conf"
# 
#   end
# 
# end