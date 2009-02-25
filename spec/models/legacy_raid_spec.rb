# == Schema Information
# Schema version: 20090225185730
#
# Table name: mgdkp_raids
#
#  raid_id         :integer(4)      not null, primary key
#  raid_name       :string(255)
#  raid_date       :integer(4)      default(0), not null
#  raid_note       :string(255)
#  raid_value      :float           default(0.0), not null
#  raid_added_by   :string(30)      default(""), not null
#  raid_updated_by :string(30)
#  raid_thread     :integer(4)      default(0), not null
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LegacyRaid do
  before(:each) do
    @params = {
      :raid_name   => '2001-01-01',
      :raid_note   => 'Notes',
      :raid_thread => 12345,
    }
    
    @legacy = LegacyRaid.create(@params)
    10.times do
      LegacyAttendee.create(:member_name => Member.make.name, 
        :raid_id => @legacy.id, :raid_attendance => 1.00)
    end
  end
  
  it "should return raid_name as its date" do
    @legacy.date.should == @params[:raid_name]
  end
  
  it "should return raid_note" do
    @legacy.note.should == @params[:raid_note]
  end
  
  it "should return raid_thread" do
    @legacy.thread.should == @params[:raid_thread]
  end
end
