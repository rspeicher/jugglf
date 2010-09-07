require 'spec_helper'

describe MembersHelper do
  describe "#member_rank_with_formatting" do
    it "should return member.name if member.rank is nil" do
      m = Factory(:member)
      member_with_rank_formatting(m).should eql(m.name)
    end

    it "should return a formatted name if member.rank is not nil" do
      m = Factory(:declined_applicant)
      member_with_rank_formatting(m).should eql("<b>#{m.name}</b>")
    end

    it "should ignore a nil value" do
      lambda { member_with_rank_formatting(nil) }.should_not raise_error
    end
  end

  describe "#link_to_member" do
    it "should return nil if member is nil" do
      link_to_member(nil).should eql(nil)
    end

    it "should apply wow class as CSS class" do
      m = Factory(:member)
      link_to_member(m).should match(/class="Druid"/)
    end
  end

  describe "#member_raid_attendance" do
    it "should return zero for non-attended raid" do
      raid = Factory(:raid)
      member_raid_attendance(raid, mock_model(Member)).should match(/0%/)
    end

    it "should return member attendance for attended raid" do
      raid = Factory(:raid_with_attendee)
      member_raid_attendance(raid, raid.attendees[0].member).should match(/100%/)
    end

    it "should ignore nil values" do
      lambda { member_raid_attendance(nil, nil) }.should_not raise_error
    end
  end

  describe "#member_attendance_colored" do
    it "should classify as negative for 0-34" do
      member_attendance_colored(18).should match(/negative/)
    end

    it "should classify as neutral for 35-66" do
      member_attendance_colored(48).should match(/neutral/)
    end

    it "should classify as positive for 67-100" do
      member_attendance_colored(88).should match(/positive/)
    end

    it "should otherwise classify as neutral" do
      member_attendance_colored(-1).should match(/neutral/)
    end

    it "should handle a float value" do
      member_attendance_colored(0.1234).should match(/12%/)
    end

    it "should ignore a nil value" do
      lambda { member_attendance_colored(nil) }.should_not raise_error
    end
  end

  describe "#raid_attendance_colored" do
    it "should classify as positive for 100"do
      raid_attendance_colored(100).should match(/positive/)
    end

    it "should classify as neutral for 1-99" do
      raid_attendance_colored(50).should match(/neutral/)
    end

    it "should classify as negative for 0" do
      raid_attendance_colored(0).should match(/negative/)
    end

    it "should handle a float value" do
      raid_attendance_colored(0.1234).should match(/12%/)
    end

    it "should ignore a nil value" do
      lambda { raid_attendance_colored(nil) }.should_not raise_error
    end
  end

  describe "#loot_factor" do
    it "should format a value" do
      loot_factor(1).should eql('1.00')
    end
  end

  describe "#warn_if_recently_looted" do
    before do
      @item = Factory(:item)
      @wishlist = Factory(:wishlist, :item => @item)
      @member = @wishlist.member
      @recent_loots = [Factory(:loot, :purchased_on => Date.today, :item => @item, :member => @member, :best_in_slot => true)]
    end

    it "should display a warning if the wishlist item of this type was recently looted" do
      @wishlist.priority = 'best in slot'
      warn_if_recently_looted(@wishlist, @recent_loots).should match(/error\.png/)
    end

    it "should not display a warning if the wishlist item was looted, but of a different type" do
      @wishlist.priority = 'normal'
      warn_if_recently_looted(@wishlist, @recent_loots).should be_nil
    end

    it "should not display an image if the wishlist item wasn't looted" do
      @recent_loots = []
      warn_if_recently_looted(@wishlist, @recent_loots).should be_nil
    end
  end
end
