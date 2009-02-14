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
    @valid_attributes = {
      :reason  => 'Reason',
      :expires => 1.day.from_now,
      :value   => 1.00
    }
  end

  it "should create a new instance given valid attributes" do
    Punishment.create!(@valid_attributes)
  end
  
  it "should forcibly expire" do
    p = Punishment.create(:reason => 'Because I said so', :expires => 30.days.from_now)
    
    p.expire!
    p.expires.should_not >= Date.today
  end
end
