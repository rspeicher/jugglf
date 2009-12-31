# == Schema Information
#
# Table name: live_loots
#
#  id        :integer(4)      not null, primary key
#  loot_type :string(255)
#  item_id   :integer(4)
#  member_id :integer(4)
#

require 'spec_helper'

describe LiveLoot do
  before(:each) do
    # Saving it might force an item lookup, which we don't want
    @live_loot = LiveLoot.make_unsaved
  end
  
  it "should be valid" do
    @live_loot.should be_valid
  end
  
  it { should belong_to(:item) }
  it { should belong_to(:member) }
  
  it { should allow_value(nil).for(:loot_type) }
  it { should allow_value('bis').for(:loot_type) }
  it { should allow_value('rot').for(:loot_type) }
  it { should allow_value('sit').for(:loot_type) }
  it { should allow_value('bisrot').for(:loot_type) }
  it { should_not allow_value('invalid').for(:loot_type) }
  it { should_not allow_value('BiS').for(:loot_type) }
  
  it { should allow_mass_assignment_of(:wow_id) }
  it { should allow_mass_assignment_of(:item_id) }
  it { should allow_mass_assignment_of(:member_id) }
  it { should allow_mass_assignment_of(:member_name) }
  it { should allow_mass_assignment_of(:loot_type) }
end

describe LiveLoot, "item assocation" do
  describe "with an existing item" do
    before(:each) do
      @item = Item.make(:wow_id => 12345, :name => 'LiveLootItem')
      @live_loot = LiveLoot.make_unsaved(:wow_id => nil, :member_name => nil)
    end
  
    it "should set the value of item_id based on wow_id, if given" do
      lambda { @live_loot.wow_id = 12345 }.should change(@live_loot, :item_id).to(@item.id)
    end
  end
  
  describe "with a new item" do
    # TODO: Should we just let it make the item?
  end
end

describe LiveLoot, "member association" do
  describe "with an existing member" do
    before(:each) do
      @member = Member.make(:name => 'LiveLooter')
      @live_loot = LiveLoot.make_unsaved(:wow_id => nil, :member_name => nil)
    end
  
    it "should set the value of member_id based on member_name" do
      lambda { @live_loot.member_name = 'LiveLooter' }.should change(@live_loot, :member_id).to(@member.id)
    end
  end
  
  # describe "with a new member" do
  #   before(:each) do
  #     @live_loot = LiveLoot.make_unsaved(:wow_id => nil, :member_name => nil)
  #   end
  #   
  #   it "should raise an exception, maybe?" do
  #     lambda {
  #       @live_loot.member_name = 'InvalidMember'
  #       @live_loot.save!
  #     }.should raise_error(ActiveRecord::RecordInvalid)
  #   end
  # end
end

describe LiveLoot, ".from_text" do
  before(:all) do
    @text = "DE, Tsigo - [Death's Choice]|47303\n" +
      "Tsigo - [Death's Choice]|47303\n" +
      "Tsigo (sit) - Death's Choice|47303\n" +
      "Tsigo bis - [Death's Choice]|47303\n"
  end
  
  it "should return an empty array if no text is given" do
    LiveLoot.from_text(nil).should eql([])
  end
  
  describe "parsing invalid text" do
    it "should not parse an empty buyer string" do
      lambda { LiveLoot.from_text(" - [Death's Choice]|47303") }.should raise_error(RuntimeError)
    end
  end
  
  describe "parsing valid text" do
    before(:all) do
      [Member, Item].each(&:destroy_all)
      @member = Member.make(:name => 'Tsigo')
      @item = Item.make(:wow_id => 47303, :name => "Death's Choice")
      
      @expected = [
        { :wow_id => 47303, :item => @item, :member => nil,     :loot_type => nil },
        { :wow_id => 47303, :item => @item, :member => @member, :loot_type => nil },
        { :wow_id => 47303, :item => @item, :member => @member, :loot_type => nil },
        { :wow_id => 47303, :item => @item, :member => @member, :loot_type => 'sit' },
        { :wow_id => 47303, :item => @item, :member => @member, :loot_type => 'bis' },
      ]
      
      @loots = LiveLoot.from_text(@text)
    end
    
    it "should return an array of LiveLoot objects" do
      @loots.length.should eql(5)
      @loots[0].should be_a(LiveLoot)
    end
    
    it "should not save the LiveLoot record" do
      @loots[0].new_record?.should be_true
    end
    
    0.upto(4) do |i|
      describe "Loot #{i}" do
        %w(wow_id item member loot_type).each do |param|
          it "should correctly set the #{param} attribute" do
            @loots[i].send(param).should eql(@expected[i][param.intern])
          end
        end
      end
    end
  end
end
