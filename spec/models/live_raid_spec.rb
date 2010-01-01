require 'spec_helper'

describe LiveRaid do
  before(:each) do
    @valid_attributes = {
      :started_at => Time.now,
      :stopped_at => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    LiveRaid.create!(@valid_attributes)
  end
end
