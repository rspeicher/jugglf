require 'spec_helper'

describe Zone do
  subject { Factory(:zone) }

  it { should be_valid }
  it { should have_many(:loot_tables) }
  it { should validate_presence_of(:name) }

  it "should have a custom to_s" do
    subject.to_s.should eql("#{subject.name}")
  end
end
