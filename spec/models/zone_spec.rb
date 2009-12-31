# == Schema Information
#
# Table name: zones
#
#  id       :integer(4)      not null, primary key
#  name     :string(255)     not null
#  position :integer(4)      default(0)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Zone do
  before(:each) do
    @zone = Zone.make
  end
  
  it "should be valid" do
    @zone.should be_valid
  end
  
  it { should validate_presence_of(:name) }
end
