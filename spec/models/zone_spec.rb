# == Schema Information
# Schema version: 20090717234345
#
# Table name: zones
#
#  id       :integer(4)      not null, primary key
#  name     :string(255)     default(""), not null
#  position :integer(4)      default(0)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Zone do
  it "should be valid" do
    Zone.make.should be_valid
  end
end
