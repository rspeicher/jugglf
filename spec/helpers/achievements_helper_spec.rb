require 'spec_helper'

include AchievementsHelper

describe "achievement_icon" do
  before(:each) do
    @ach = Factory(:achievement, :icon => 'icon')
  end
  
  it "should link to a Wowhead achievement" do
    achievement_icon(@ach).should match(/wowhead\.com\/\?achievement=1/)
  end
  
  it "should contain an icon" do
    achievement_icon(@ach).should match(%r{static\.wowhead\.com/images/icons/small/icon\.jpg})
  end
end
