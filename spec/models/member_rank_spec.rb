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
