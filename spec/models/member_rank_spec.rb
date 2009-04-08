# == Schema Information
# Schema version: 20090404033151
#
# Table name: member_ranks
#
#  id     :integer(4)      not null, primary key
#  name   :string(255)
#  prefix :string(255)
#  suffix :string(255)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MemberRank do
  it "should be valid" do
    MemberRank.make.should be_valid
  end
end

# -----------------------------------------------------------------------------

describe MemberRank, "formatting" do
  describe "sanitization" do
    before(:each) do
      @rank = MemberRank.make(:name => 'Example')
    end
    
    it "should format a string" do
      @rank.format(@rank.name).should == '<b>Example</b>'
    end
    
    it "should strip javascript" do
      @rank.prefix = '<script>'
      @rank.suffix = '</script>'
      
      @rank.format('Example').should == 'Example'
    end
  end
end
