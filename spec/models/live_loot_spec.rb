# == Schema Information
#
# Table name: live_loots
#
#  id          :integer(4)      not null, primary key
#  wow_id      :integer(4)
#  item_name   :string(255)
#  member_name :string(255)
#  loot_type   :string(255)
#

require 'spec_helper'

describe LiveLoot do
  before(:each) do
    @live_loot = LiveLoot.make
  end
  
  it "should be valid" do
    @live_loot.should be_valid
  end
  
  it { should validate_presence_of(:item_name) }
  
  it { should allow_value(nil).for(:loot_type) }
  it { should allow_value('bis').for(:loot_type) }
  it { should allow_value('rot').for(:loot_type) }
  it { should allow_value('sit').for(:loot_type) }
  it { should allow_value('bisrot').for(:loot_type) }
  it { should_not allow_value('invalid').for(:loot_type) }
  it { should_not allow_value('BiS').for(:loot_type) }
  
  it { should allow_mass_assignment_of(:wow_id) }
  it { should allow_mass_assignment_of(:item_name) }
  it { should allow_mass_assignment_of(:member_name) }
  it { should allow_mass_assignment_of(:loot_type) }
end

describe LiveLoot, ".from_text" do
  before(:all) do
    @text = "DE, Tsigo - [Snowserpent Mail Helm]|49952\n" +
      "Duskshadow - [Crushing Coldwraith Belt]|49978\n" +
      "Sebudai (sit) - Stygian Bladebreaker|47255\n" +
      "Kazanir bis - [Death's Choice]|47303\n"
  end
  
  it "should return an empty array if no text is given" do
    LiveLoot.from_text(nil).should eql([])
  end
  
  describe "parsing" do
    before(:all) do
      @expected = [
        { :wow_id => 49952, :item_name => "Snowserpent Mail Helm",    :member_name => nil,          :loot_type => nil },
        { :wow_id => 49952, :item_name => "Snowserpent Mail Helm",    :member_name => "Tsigo",      :loot_type => nil },
        { :wow_id => 49978, :item_name => "Crushing Coldwraith Belt", :member_name => "Duskshadow", :loot_type => nil },
        { :wow_id => 47255, :item_name => "Stygian Bladebreaker",     :member_name => "Sebudai",    :loot_type => 'sit' },
        { :wow_id => 47303, :item_name => "Death's Choice",           :member_name => "Kazanir",    :loot_type => 'bis' },
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
        %w(wow_id item_name member_name loot_type).each do |param|
          it "should correctly set the #{param} attribute" do
            @loots[i].send(param).should eql(@expected[i][param.intern])
          end
        end
      end
    end
  end
end