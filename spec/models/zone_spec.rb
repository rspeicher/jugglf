require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Zone do
  it "should be valid" do
    Zone.make.should be_valid
  end
end
