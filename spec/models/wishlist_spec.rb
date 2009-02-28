require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Wishlist do
  before(:each) do
    @wishlist = Wishlist.make
  end
  it "should be valid" do
    @wishlist.should be_valid
  end
  
  it "should not allow invalid priority types" do
    @wishlist.priority = 'invalid'
    lambda { @wishlist.save! }.should raise_error
  end
end
