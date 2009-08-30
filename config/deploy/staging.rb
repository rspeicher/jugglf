set :domain,      "staging.tsigo.org"
set :repository,  "git@gluttony:#{application}.git"
set :scm,         'git'
set :branch,      'master'

role :app, domain
role :web, domain
role :db,  domain, :primary => true