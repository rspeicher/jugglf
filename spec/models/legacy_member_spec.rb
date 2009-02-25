# == Schema Information
# Schema version: 20090225185730
#
# Table name: mgdkp_members
#
#  member_id         :integer(4)      not null, primary key
#  member_name       :string(30)      default(""), not null
#  member_earned     :float           default(0.0), not null
#  member_spent      :float           default(0.0), not null
#  member_adjustment :float           default(0.0), not null
#  member_status     :boolean(1)      default(TRUE), not null
#  member_firstraid  :integer(4)      default(0), not null
#  member_lastraid   :integer(4)      default(0), not null
#  member_raidcount  :integer(4)      default(0), not null
#  member_level      :integer(1)      default(70), not null
#  member_race_id    :integer(2)      default(0), not null
#  member_class_id   :integer(2)      default(0), not null
#  member_rank_id    :integer(2)      default(0), not null
#  member_lf         :float           default(0.0), not null
#  member_slf        :float           default(0.0), not null
#  member_bis        :float           default(0.0), not null
#  member_30         :float           default(0.0), not null
#  member_90         :float           default(0.0), not null
#  member_lt         :float           default(0.0), not null
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LegacyMember do
  CLASSES = Member::WOW_CLASSES.push(Member::WOW_CLASSES.shift) # Move Death Knight to the back
  
  before(:each) do
    @params = {
      :member_name     => 'MemberName',
      :member_earned   => 1.23,
      :member_spent    => 4.56,
      :member_status   => 1,
      :member_class_id => 0,
      :member_rank_id  => 1,
      :member_lf       => 7.89,
      :member_slf      => 10.11,
      :member_bis      => 12.13,
      :member_30       => 1.00,
      :member_90       => 0.75,
      :member_lt       => 0.50
    }
    
    @legacy = LegacyMember.create(@params)
  end
  
  it "should return member_name" do
    @legacy.name.should == @params[:member_name]
  end
  
  describe "#active" do
    it "should be true when member is active and not in ranks 5 or 6" do
      @legacy.active?.should be_true
    end
    
    it "should be false when member is inactive" do
      @legacy.member_status = 0
      @legacy.active?.should be_false
    end
    
    it "should be false when member is rank 5 or 6" do
      @legacy.member_rank_id = 5
      @legacy.active?.should be_false
    end
  end
  
  describe "#wow_class" do
    CLASSES.each_index do |index|
      it "should return #{CLASSES[index]} for #{index+1}" do
        @legacy.member_class_id = index + 1
        @legacy.wow_class.should == CLASSES[index]
      end
    end
  end
  
  it "should return member_lf" do
    @legacy.lf.should == @params[:member_lf]
  end
  
  it "should return member_slf" do
    @legacy.sitlf.should == @params[:member_slf]
  end
  
  it "should return member_bislf" do
    @legacy.bislf.should == @params[:member_bis]
  end
  
  it "should return member_30" do
    @legacy.attendance_30.should == @params[:member_30]
  end
  
  it "should return member_90" do
    @legacy.attendance_90.should == @params[:member_90]
  end
  
  it "should return member_lt" do
    @legacy.attendance_lifetime.should == @params[:member_lt]
  end
end
