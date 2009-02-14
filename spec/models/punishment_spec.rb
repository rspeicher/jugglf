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
