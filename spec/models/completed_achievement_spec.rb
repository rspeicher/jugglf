# == Schema Information
# Schema version: 20090404033151
#
# Table name: completed_achievements
#
#  id             :integer(4)      not null, primary key
#  member_id      :integer(4)
#  achievement_id :integer(4)
#  completed_on   :date
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CompletedAchievement do
  before(:each) do
    @completed = CompletedAchievement.make
  end
  
  it "should be valid" do
    @completed.should be_valid
  end
end

describe CompletedAchievement, "#parse_member" do
  before(:each) do
    [Achievement, CompletedAchievement].each(&:destroy_all)
    @member = Member.make(:name => 'Tsigo')
    
    # Add one pre-existing completed achievement
    @complete = Achievement.make(:armory_id => 2887, :category_id => 168,
      :title => 'Heroic: The Siege of Ulduar')
    @complete.members << @member
    
    # Add one pre-existing achievement
    @incomplete = Achievement.make(:armory_id => 2904, :category_id => 168,
      :title => "Conqueror of Ulduar")
    
    CompletedAchievement.stub!(:open).
      and_return(File.read(RAILS_ROOT + '/spec/fixtures/armory/achievements_tsigo.xml'))
  end
  
  it "set up environment" do
    @member.completed_achievements.count.should == 1
    Achievement.count.should == 2
  end
  
  it "should not parse this member if this member has completed all known achievements" do
    @incomplete.members << @member
    CompletedAchievement.should_not_receive(:open)
    CompletedAchievement.parse_member(@member)
  end
  
  it "should create new Achievement records for achievements which don't exist" do
    lambda { CompletedAchievement.parse_member(@member) }.should change(Achievement, :count).
      by(60) # 62 achievements, 2 pre-existing
  end
  
  it "should not create a completed achievement record for an incomplete achievement" do
    lambda { CompletedAchievement.parse_member(@member) }.should change(CompletedAchievement, :count).
      to(18) # 62 achievements, 18 complete
  end
end
