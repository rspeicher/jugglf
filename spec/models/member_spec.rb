require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Member do
  fixtures :members
  
  before(:all) do
    @valid_attributes = {
      :name => 'Name'
    }
  end

  it "should create a new instance given valid attributes" do
    Member.create!(@valid_attributes)
  end
  
  it "should not recache with a recent updated_at" do
    members(:tsigo).should_recache?.should == false
  end
  
  it "should recache with an outdated updated_at" do
    members(:sebudai).should_recache?.should == true
  end
  
  it "should recache when uncached_updates is beyond the threshold" do
    m = members(:tsigo)
    m.uncached_updates = Member::CACHE_FLUSH
    m.should_recache?.should == true
  end
  
  it "should update the uncached_updates attribute" do
    m = members(:tsigo)
    m.uncached_updates.should == 0
    
    1.upto(Member::CACHE_FLUSH - 1) do |x|
      m.attendance_30 = 1.00 * x.to_f
      m.save!
      m.uncached_updates.should == x
    end
    
    m.attendance_30 = 40.00
    m.save! # This save should trigger the update_cache method
    m.uncached_updates.should == 0
  end
  
  it "should validate wow_class" do
    m = Member.new(:name => "NoClass", :wow_class => nil)
    m.should be_valid
    
    m = Member.new(:name => "EverQuest", :wow_class => "Necromancer")
    m.should_not be_valid
  end

  it "should require a name" do
    m = Member.new
    m.should_not be_valid
    
    m.name = @valid_attributes[:name]
    m.should be_valid
  end
  
  it "should invalidate duplicate names" do
    m = Member.new(:name => 'Tsigo')
    m.should_not be_valid
    
    m.name = 'Tsigo2'
    m.should be_valid
  end
end

describe Member, " cache" do
  fixtures :items, :members, :raids
  
  it "should update cache on existing member" do
    m = members(:update_cache)
    m.should_recache?.should == true
    
    # Add raid attendance
    m.attendance << Attendee.create(:raid_id => raids(:today).id, :attendance => 1.00)
    m.attendance << Attendee.create(:raid_id => raids(:yesterday).id, :attendance => 1.00)
    
    # Add an item
    m.items << Item.create(:name => 'Normal LF', :price => 5.00, 
      :raid_id => raids(:yesterday).id)
    m.items << Item.create(:name => 'Sit LF', :price => 30.00, 
      :raid_id => raids(:today).id, :situational => true)
    m.items << Item.create(:name => 'BiS LF, Not Affected', :price => 10.00, 
      :raid_id => raids(:two_months_ago).id, :best_in_slot => true)
    m.items << Item.create(:name => 'BiS LF', :price => 3.14, 
      :raid_id => raids(:yesterday).id, :best_in_slot => true)
    m.items.size.should == 4
    
    m.save!
    m.force_recache!
    
    m = Member.find_by_name('UpdateMyCache')
    m.attendance_30.should == 1.00
    m.attendance_90.should == 0.666667
    
    m.lf.should    == 5.00
    m.sitlf.should == 30.00
    m.bislf.should == 3.14
  end
  
  it "should update cache on new member" do
    m = Member.new(:name => "NewCache")
    m.should_recache?.should_not == true
    
    # Add raid attendance
    m.attendance << Attendee.create(:raid_id => raids(:today).id, :attendance => 1.00)
    m.attendance << Attendee.create(:raid_id => raids(:yesterday).id, :attendance => 1.00)
    m.uncached_updates += 2
    
    # Add an item
    m.items << Item.create(:name => 'Normal LF', :price => 5.00, 
      :raid_id => raids(:yesterday).id)
    m.items << Item.create(:name => 'Sit LF', :price => 30.00, 
      :raid_id => raids(:today).id, :situational => true)
    m.items << Item.create(:name => 'BiS LF, Not Affected', :price => 10.00, 
      :raid_id => raids(:two_months_ago).id, :best_in_slot => true)
    m.items << Item.create(:name => 'BiS LF', :price => 3.14, 
      :raid_id => raids(:yesterday).id, :best_in_slot => true)
    m.items.size.should == 4
    m.uncached_updates += 4
    
    m.should_recache?.should == true
    m.save!
    m.force_recache!
    
    m = Member.find_by_name('NewCache')
    m.attendance_30.should == 1.00
    m.attendance_90.should == 0.666667
    
    m.lf.should    == 5.00
    m.sitlf.should == 30.00
    m.bislf.should == 3.14
  end
end

describe Member, " with raid attendance" do
  fixtures :members, :raids
  
  it "has raid attendance" do
    m = members(:tsigo)
    m.attendance.size.should == 0
    m.raids << raids(:today)
    m.raids << raids(:yesterday)
    m.save
    m.reload
    
    m.attendance.size.should == 2
  end
end

describe Member, " with item purchases" do
  fixtures :items, :members
  
  it "has an item purchase" do
    m = members(:tsigo)
    m.items.size.should == 0
    
    i = Item.create(:name => 'Warglaive of Azzinoth', :price => 5.00)
    m.items << i
    
    m.items.size.should == 1
    m.should == i.buyer
  end
end