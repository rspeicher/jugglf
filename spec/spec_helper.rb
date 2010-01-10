# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
require 'spec/autorun'
require 'spec/rails'
require 'fakeweb'
require 'shoulda'

require 'invision_bridge'
require 'blueprints'
require 'login_helper'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

# Uncomment to not quiet backtrace
# Rails.backtrace_cleaner.remove_silencers!

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  
  config.before(:all)    { Sham.reset(:before_all)  }
  config.before(:each)   { Sham.reset(:before_each) }
  
  config.include(LoginHelper)
  
  # TEMP: Using this to figure out which specs are tainting my database
  # config.after(:all) do
  #   Achievement.count.should eql(0)
  #   Attendee.count.should eql(0)
  #   Boss.count.should eql(0)
  #   CompletedAchievement.count.should eql(0)
  #   Item.count.should eql(0)
  #   LiveAttendee.count.should eql(0)
  #   LiveLoot.count.should eql(0)
  #   LiveRaid.count.should eql(0)
  #   Loot.count.should eql(0)
  #   LootTable.count.should eql(0)
  #   Member.count.should eql(0)
  #   MemberRank.count.should eql(0)
  #   Punishment.count.should eql(0)
  #   Raid.count.should eql(0)
  #   Session.count.should eql(0)
  #   # User.count.should eql(0) # I don't think this is taint so much as existing users
  #   Wishlist.count.should eql(0)
  #   Zone.count.should eql(0)
  # end
  
  FakeWeb.allow_net_connect = false

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  #
  # For more information take a look at Spec::Runner::Configuration and Spec::Runner
end

def file_fixture(*args)
  File.read(File.join(File.dirname(__FILE__), "file_fixtures", args))
end

module ItemLookupHelpers
  def valid_lookup_results
    results = ItemLookup::Results.new
    result = ItemLookup::Result.new({
      :id      => 40395,
      :name    => 'Torch of Holy Fire',
      :quality => 4,
      :icon    => 'INV_Mace_82',
      :level   => 226,
      :heroic  => false
    })
    results << result
  end
  def invalid_lookup_results
    results = ItemLookup::Results.new
    result = ItemLookup::Result.new
    results << result
  end
end