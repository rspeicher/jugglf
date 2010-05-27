require 'spec_helper'

describe LootTable do
  before(:each) do
    @table = Factory(:loot_table, :object => nil, :parent => nil)
  end

  it "should return its object's name for to_s" do
    @table.object = Factory(:boss)
    @table.to_s.should eql('Boss')
  end

  context "mass assignment" do
    it { should_not allow_mass_assignment_of(:id) }
    it { should allow_mass_assignment_of(:object) }
    it { should allow_mass_assignment_of(:object_id) }
    it { should allow_mass_assignment_of(:parent_id) }
    it { should allow_mass_assignment_of(:note) }
  end

  context "polymorphic associations" do
    before(:each) do
      @zone = Factory(:zone)
      @boss = Factory(:boss)
      @item = Factory(:item)
    end

    it "should take a zone record" do
      @table.object = @zone
      @table.should be_valid
      @table.object_type.should eql('Zone')
    end

    it "should take a boss record" do
      @table.object = @boss
      @table.should be_valid
      @table.object_type.should eql('Boss')
    end

    it "should take an item record" do
      @table.object = @item
      @table.should be_valid
      @table.object_type.should eql('Item')
      @table.object.should eql(@item)
    end
  end

  it "should act_as_tree" do
    @table = Factory(:loot_table)
    @table.parent.object.should be_a Boss
    @table.parent.parent.object.should be_a Zone
  end
end
