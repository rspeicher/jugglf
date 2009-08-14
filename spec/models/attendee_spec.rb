require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Attendee do
  before(:each) do
    Member.destroy_all
    @attendee = Attendee.make
  end
  
  it "should be valid" do
    @attendee.should be_valid
  end
end
