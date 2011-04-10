source :gemcutter

gem 'rails', '3.0.4'
gem 'mysql'

gem 'authlogic',        '~> 2.1', :git => 'git://github.com/radar/authlogic.git'
gem 'formtastic',       '~> 1.2'
gem 'haml',             '~> 3.0'
gem 'hoptoad_notifier', '~> 2.3'
gem 'invision_bridge',  '~> 0.3'
gem 'nokogiri',         '~> 1.4'
gem 'will_paginate',    '3.0.pre2'

group :development, :test do
  gem 'fakeweb',            '~> 1.3'
  gem 'factory_girl',       '~> 1.3'
  gem 'factory_girl_rails', '~> 1.0'
  gem 'mocha',              '~> 0.9'
  gem 'rspec',              '~> 2.5'
  gem 'rspec-rails',        '~> 2.5'
  gem 'shoulda',            '~> 2.11'
  gem 'timecop',            '~> 0.3'
end

group :test do
  gem 'cucumber',        '~> 0.10'
  gem 'cucumber-rails',  '~> 0.4'
  gem 'database_cleaner'
  gem 'capybara'

  gem 'guard', '~> 0.3'
  gem 'guard-bundler'
  gem 'guard-cucumber'
  gem 'guard-rspec'
end

# These gems are developer-specific and shouldn't be required on every
# goddamn installation but Bundler is kind of fucking us here.
# See https://github.com/carlhuda/bundler/issues/labels/feature#issue/183
# group :development, :test do
#   gem 'ruby-debug'
#   gem 'launchy'
# end

group :production do
  gem 'whenever', '~> 0.6'
end
