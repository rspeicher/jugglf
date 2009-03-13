require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include AchievementsHelper

describe AchievementsHelper do
  describe "achievement_icon" do
    before(:each) do
      @ach = Achievement.make
    end
    
    it "should link to a Wowhead achievement" do
      achievement_icon(@ach).should match(/wowhead\.com\/\?achievement=12345/)
    end
    
    it "should contain an icon" do
      achievement_icon(@ach).should match(/static\.wowhead\.com\/images\/icons\/small\/icon\.jpg/)
    end
  end
end
