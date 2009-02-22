# == Schema Information
# Schema version: 20090213233547
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
  before(:all) do
    @valid_attributes = {
      :name => 'Name'
    }
  end

  it "should create a new instance given valid attributes" do
    MemberRank.create!(@valid_attributes)
  end
  
  it "should require a name" # do
   #    mr = MemberRank.create
   #    mr.should_not be_valid
   #    mr.should have(1).errors_on(:name)
   #  end
  
  # ---------------------------------------------------------------------------
  
  describe "sanitization" do
    before(:all) do
      @mr = MemberRank.create(:name => 'Sanitization', :prefix => '<b>', 
        :suffix => '</b>')
      
      @html = {
        :xss        => '<javascript>Content</javascript>',
        :span_style => '<span style="color: green">Content</span>',
        :span_class => '<span class="Druid">Content</span>',
        :opening    => '<b>',
      }
    end
    
    it "should format a string" # do
     #      @mr.format('Tsigo').should == '<b>Tsigo</b>'
     #    end
    
    # it "should allow span" do
    #   @mr.prefix = @html[:span_style]
    #   @mr.prefix.should == @html[:span_style]
    #   
    #   @mr.prefix = @html[:span_class]
    #   @mr.prefix.should == @html[:span_class]
    # end
    # 
    # it "should allow no closing tag" do
    #   @mr.prefix = @html[:opening]
    #   @mr.prefix.should == @html[:opening]
    # end
    # 
    # it "should not allow javascript" do
    #   @mr.prefix = @html[:xss]
    #   @mr.prefix.should_not == @html[:xss]
    # end
  end
end
