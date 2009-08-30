set :domain,      "lf.juggernautguild.com"
set :repository,  "git@tsigo.com:#{application}.git"
set :scm,         'git'
set :branch,      'master'

set :deploy_to,   "/var/www/rails/#{application}"

role :app, domain
role :web, domain
role :db,  domain, :primary => true