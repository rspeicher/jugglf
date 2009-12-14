# == Schema Information
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
  before(:all) do
    Member.destroy_all
    @member = Member.make(:name => 'Tsigo')
    
    FakeWeb.register_uri(:get, "http://www.wowarmory.com/character-achievements.xml?r=Mal%27Ganis&n=Tsigo&c=168", :body => File.read(File.dirname(__FILE__) + "/../fixtures/wowarmory/achievements_tsigo.xml"))
  end
  
  before(:each) do
    [Achievement, CompletedAchievement].each(&:destroy_all)
    
    # Add one pre-existing completed achievement
    # <achievement categoryId="168" dateCompleted="2009-12-09T03:25:00-06:00" desc="Defeat the first four bosses in Icecrown Citadel in 25-player mode." icon="achievement_dungeon_icecrown_icecrownentrance" id="4604" points="10" title="Storming the Citadel (25 player)">
    # ...
    # </achievement>
    @complete = Achievement.make(:armory_id => 4604, :category_id => 168,
      :title => 'Storming the Citadel (25 player)')
    @complete.members << @member
    
    # Add one pre-existing achievement
    # <achievement categoryId="168" desc="Defeat the bosses of The Plagueworks in Icecrown Citadel in 25-player mode." icon="achievement_dungeon_plaguewing" id="4605" points="10" title="The Plagueworks (25 player)">
    # ...
    # </achievement>
    @incomplete = Achievement.make(:armory_id => 4605, :category_id => 168,
      :title => "The Plagueworks (25 player)")
  end
  
  it "set up environment" do
    @member.completed_achievements.count.should eql(1)
    Achievement.count.should eql(2)
  end
  
  it "should not parse this member if this member has completed all known achievements" do
    @incomplete.members << @member
    CompletedAchievement.should_not_receive(:open)
    CompletedAchievement.parse_member(@member)
  end
  
  it "should create new Achievement records for achievements which don't exist" do
    lambda { CompletedAchievement.parse_member(@member) }.should change(Achievement, :count).
      by(19) # 21 achievements, 2 pre-existing
  end
  
  it "should not create a completed achievement record for an incomplete achievement" do
    lambda { CompletedAchievement.parse_member(@member) }.should change(CompletedAchievement, :count).
      to(2) # 21 achievements, 2 complete
  end
end
