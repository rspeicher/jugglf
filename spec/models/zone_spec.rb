require 'spec_helper'

describe Zone do
  before(:each) do
    @zone = Factory(:zone)
  end

  it "should be valid" do
    @zone.should be_valid
  end

  it { should have_many(:loot_tables) }

  it { should validate_presence_of(:name) }

  it "should have a custom to_s" do
    @zone.to_s.should eql("#{@zone.name}")
  end
end
