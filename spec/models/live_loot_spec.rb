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
