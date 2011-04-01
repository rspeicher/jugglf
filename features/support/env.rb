ENV["RAILS_ENV"] ||= "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')

require "cucumber/rails"
require "capybara/rails"
require "capybara/cucumber"
require "capybara/session"

Capybara.default_selector = :css

Before do
  User.delete_all
end

if defined?(ActiveRecord::Base)
  begin
    require 'database_cleaner'
    require 'database_cleaner/cucumber'
    DatabaseCleaner.strategy = :transaction
  rescue LoadError => ignore_if_database_cleaner_not_present
  end
end
