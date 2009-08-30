set :domain,      "lf.juggernautguild.com"
set :repository,  "git@tsigo.com:#{application}.git"
set :scm,         'git'
set :branch,      'master'

role :app, domain
role :web, domain
role :db,  domain, :primary => true