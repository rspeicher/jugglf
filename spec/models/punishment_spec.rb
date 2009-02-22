# == Schema Information
# Schema version: 20090213233547
#
# Table name: punishments
#
#  id         :integer(4)      not null, primary key
#  member_id  :integer(4)
#  reason     :string(255)
#  expires    :date
#  value      :float           default(0.0)
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Punishment do
  before(:each) do
    @punishment = Punishment.make
    @expired    = Punishment.make(:expired)
  end
  
  it "should be valid" do
    @punishment.should be_valid
  end
  
  it "should forcibly expire" do
    @punishment.expire!
    @punishment.expires.should_not >= Date.today
  end
  
  it "should find all active punishments" do
    Punishment.find_all_active.size.should == 1
  end
  
  describe "#expires_string" do
    it "should set expires date from a string" do
      @punishment.expires_string = 1.year.until(Date.today).to_s
      @punishment.expires.to_date.should == 1.year.until(Date.today)
    end

    it "should return expires as a string" do
      @punishment.expires_string.should == Date.tomorrow
    end

    it "should return a date 56 days from now if expires is not yet set" do
      @punishment.expires = nil
      @punishment.expires_string.should == 56.days.from_now.to_date
    end
  end
end

# -----------------------------------------------------------------------------

describe Punishment, "callbacks" do
  before(:each) do
    @member = Member.make
    @member.punishments.make
    @member.reload
  end
  
  it "should update member cache after save" do
    @member.lf.should_not == 0.00
  end
  
  it "should update member cache after expire!" do
    @member.punishments.find(:last).expire!
    @member.reload
    @member.lf.should == 0.00
  end
  
  it "should update member cache after destroy" do
    Punishment.destroy_all
    @member.reload
    @member.lf.should == 0.00
  end
end