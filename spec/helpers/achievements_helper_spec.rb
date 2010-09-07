require 'spec_helper'

describe AchievementsHelper do
  describe "#achievement_icon" do
    let(:achievement) { Factory(:achievement, :icon => 'icon') }

    it "should link to a Wowhead achievement" do
      achievement_icon(achievement).should match(/wowhead\.com\/\?achievement=1/)
    end

    it "should contain an icon" do
      achievement_icon(achievement).should match(%r{static\.wowhead\.com/images/wow/icons/small/icon\.jpg})
    end
  end
end
