require 'spec_helper'

describe CompletedAchievement do
  before(:each) do
    @completed = Factory(:completed_achievement)
  end

  it "should be valid" do
    @completed.should be_valid
  end

  context "mass assignment" do
    it { should_not allow_mass_assignment_of(:id) }
    it { should allow_mass_assignment_of(:member) }
    it { should allow_mass_assignment_of(:member_id) }
    it { should allow_mass_assignment_of(:achievement) }
    it { should allow_mass_assignment_of(:achievement_id) }
    it { should allow_mass_assignment_of(:completed_on) }
  end

  context "associations" do
    it { should belong_to(:achievement) }
    it { should belong_to(:member) }
  end

  context "validations" do
    it { should validate_presence_of(:achievement) }
    it { should validate_presence_of(:member) }
  end
end

describe CompletedAchievement, "#parse_member" do
  before(:each) do
    FakeWeb.register_uri(:get, %r{http://www\.wowarmory\.com/character-achievements\.xml}, :body => file_fixture('wowarmory', 'achievements_tsigo.xml'))

    @member = Factory(:member)

    # Add one pre-existing completed achievement
    # <achievement categoryId="168" dateCompleted="2009-12-09T03:25:00-06:00" desc="Defeat the first four bosses in Icecrown Citadel in 25-player mode." icon="achievement_dungeon_icecrown_icecrownentrance" id="4604" points="10" title="Storming the Citadel (25 player)">
    # ...
    # </achievement>
    @complete = Factory(:achievement, :armory_id => 4604, :category_id => 168, :title => 'Storming the Citadel (25 player)')
    Factory(:completed_achievement, :member => @member, :achievement => @complete)

    # Add one pre-existing achievement
    # <achievement categoryId="168" desc="Defeat the bosses of The Plagueworks in Icecrown Citadel in 25-player mode." icon="achievement_dungeon_plaguewing" id="4605" points="10" title="The Plagueworks (25 player)">
    # ...
    # </achievement>
    @incomplete = Factory(:achievement, :armory_id => 4605, :category_id => 168, :title => "The Plagueworks (25 player)")
  end

  it "set up environment" do
    @complete.members.size.should eql(1)
    @incomplete.members.size.should eql(0)
    @member.completed_achievements.count.should eql(1)
    Achievement.count.should eql(2)
  end

  it "should not parse this member if this member has completed all known achievements" do
    Factory(:completed_achievement, :member => @member, :achievement => @incomplete)
    CompletedAchievement.expects(:open).never
    CompletedAchievement.parse_member(@member)
  end

  it "should create new Achievement records for achievements which don't exist" do
    lambda { CompletedAchievement.parse_member(@member) }.should change(Achievement, :count).
      by(19) # 21 achievements, 2 pre-existing
  end

  it "should not create a completed achievement record for an incomplete achievement" do
    lambda { CompletedAchievement.parse_member(@member) }.should change(CompletedAchievement, :count).
      from(1).to(2) # 21 achievements, 2 complete
  end
end
