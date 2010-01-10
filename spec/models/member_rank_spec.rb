# == Schema Information
#
# Table name: member_ranks
#
#  id     :integer(4)      not null, primary key
#  name   :string(255)
#  prefix :string(255)
#  suffix :string(255)
#

require 'spec_helper'

describe MemberRank do
  before(:each) do
    @rank = MemberRank.make
  end
  
  it "should be valid" do
    @rank.should be_valid
  end
  
  # it { should have_one(:member) } # FIXME: Expected MemberRank to have a has_one association called member (Member does not have a member_rank_id foreign key.)
  
  it { should validate_presence_of(:name) }
  
  it "should have a custom to_s" do
    @rank.to_s.should eql("#{@rank.name}")
  end
end

# -----------------------------------------------------------------------------

describe MemberRank, "formatting" do
  describe "sanitization" do
    before(:each) do
      @rank = MemberRank.make(:name => 'Example')
    end
    
    it "should format a string" do
      @rank.format(@rank.name).should eql('<b>Example</b>')
    end
    
    # it "should strip javascript" do
    #   @rank.prefix = '<script>'
    #   @rank.suffix = '</script>'
    #   
    #   @rank.format('Example').should eql('Example')
    # end
  end
end
