require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Member do
  fixtures :members
  
  before(:each) do
    @valid_attributes = {
      :name => 'Name'
    }
  end

  it "should create a new instance given valid attributes" do
    Member.create!(@valid_attributes)
  end
  
  it "should not recache with a recent updated_at" do
    members(:tsigo).should_recache?.should == false
  end
  
  it "should recache with an outdated updated_at" do
    members(:sebudai).should_recache?.should == true
  end
  
  it "should recache when uncached_updates is beyond the threshold" do
    m = members(:tsigo)
    m.uncached_updates = Member::CACHE_FLUSH
    m.should_recache?.should == true
  end
end
