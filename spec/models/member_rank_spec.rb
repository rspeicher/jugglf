require 'spec_helper'

describe MemberRank do
  before(:each) do
    @rank = Factory(:member_rank)
  end

  it "should be valid" do
    @rank.should be_valid
  end

  # it { should have_one(:member) } # FIXME: Expected MemberRank to have a has_one association called member (Member does not have a member_rank_id foreign key.)

  context "validations" do
    it { should validate_presence_of(:name) }
  end

  it "should have a custom to_s" do
    @rank.to_s.should eql("#{@rank.name}")
  end
end

describe MemberRank, "#format" do
  before(:each) do
    @rank = Factory(:member_rank)
  end

  it "should return a formatted string" do
    @rank.format('Anything').should eql("<b>Anything</b>")
  end
end
