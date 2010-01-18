require 'spec_helper'

describe ItemLookup do
  it "should take a :source argument" do
    ItemLookup::Wowhead.should_receive(:search).with('query', { :source => 'wowhead' }).and_return(nil)
    ItemLookup.search('query', :source => 'wowhead')
  end
end

describe ItemLookup::Results do
  describe "#best_result" do
    before(:each) do
      @results = ItemLookup::Results.new

      1.upto(5) do |i|
        result       = ItemLookup::Result.new
        result.id    = i
        result.name  = "Item #{i}"
        result.level = i * 5
        @results << result
      end
    end

    it "should know the best result based on level" do
      @results.best_result.level.should eql(25) # 5 * 5
    end

    it "should return Result.new when no results present" do
      @results = ItemLookup::Results.new
      @results.best_result.should be_kind_of ItemLookup::Result
    end

    it "should return properly when one result present" do
      4.times { @results.shift }
      @results.length.should eql(1)
      @results.best_result.should eql(@results[0])
    end

    it "should return properly when no results are present" do
      @results = ItemLookup::Results.new
      @results.best_result.valid?.should be_false
    end
  end
end

describe ItemLookup::Result do
  it "should not validate by default" do
    ItemLookup::Result.new.valid?.should be_false
  end

  it "should accept properties in its initializer" do
    result = ItemLookup::Result.new(:id => 1, :name => 'a', :quality => 1, :icon => 'b', :level => 1)
    result.valid?.should be_true
  end
end

describe ItemLookup::Armory do
  it "should search wowarmory.com" do
    ItemLookup::Armory.should_receive(:search).with('Torch of Holy Fire', anything()).and_return(nil)
    ItemLookup.search('Torch of Holy Fire')
  end

  describe "when searching by id" do
    before(:all) do
      FakeWeb.register_uri(:get, 'http://www.wowarmory.com/item-tooltip.xml?i=40395', :body => file_fixture('wowarmory', 'item-tooltip_40395.xml'))
      FakeWeb.register_uri(:get, 'http://www.wowarmory.com/item-info.xml?i=40395', :body => file_fixture('wowarmory', 'item-info_40395.xml'))

      @result = ItemLookup.search('40395').best_result

      @expected = {
        :id      => 40395,
        :name    => 'Torch of Holy Fire',
        :quality => 4,
        :icon    => 'inv_mace_82',
        :level   => 226,
        :slot    => 'Main Hand',
        :heroic  => false
      }
    end

    it "should return a valid Result object" do
      @result.should be_a ItemLookup::Result
      @result.should be_valid
    end

    %w(id name quality icon level slot heroic).each do |prop|
      it "should have a #{prop}" do
        @result.send(prop.intern).should eql(@expected[prop.intern])
      end
    end
  end

  describe "when searching by name, multiple results" do
    before(:all) do
      FakeWeb.clean_registry
      FakeWeb.register_uri(:get, %r(http://www\.wowarmory\.com/search\.xml.+), :body => file_fixture('wowarmory', 'search_dark_matter.xml'))
      FakeWeb.register_uri(:get, %r(http://www\.wowarmory\.com/item-tooltip\.xml\?i=.+), :body => file_fixture('wowarmory', 'item-tooltip_46038.xml'))
      @result = ItemLookup.search('Dark Matter').best_result

      @expected = {
        :id      => 46038,
        :name    => 'Dark Matter',
        :quality => 4,
        :icon    => 'spell_shadow_seedofdestruction',
        :level   => 226,
        :slot    => 'Trinket',
        :heroic  => false
      }
    end

    %w(id name quality icon level slot heroic).each do |prop|
      it "a result should have a #{prop}" do
        @result.send(prop.intern).should eql(@expected[prop.intern])
      end
    end
  end

  describe "with no search results" do
    before(:each) do
      FakeWeb.clean_registry
      FakeWeb.register_uri(:get, %r(http://www\.wowarmory\.com/search\.xml.+), :body => file_fixture('wowarmory', 'search_no_results.xml'))
    end

    it "should return an empty array of Results" do
      ItemLookup.search('Some Junk').should be_a ItemLookup::Results
    end
  end
end

describe ItemLookup::Wowhead do
  before(:each) do
    FakeWeb.register_uri(:get, 'http://www.wowhead.com/?item=40395&xml', :body => file_fixture('wowhead', 'item_40395.xml'))
  end

  it "should search wowhead.com" do
    ItemLookup::Wowhead.should_receive(:search).with('40395', anything()).and_return(nil)
    ItemLookup.search('40395', :source => 'wowhead')
  end

  describe "results" do
    before(:all) do
      @result = ItemLookup.search('40395', :source => 'wowhead').best_result

      @expected = {
        :id      => 40395,
        :name    => 'Torch of Holy Fire',
        :quality => 4,
        :icon    => 'INV_Mace_82',
        :level   => 226,
        :slot    => 'Main Hand',
        :heroic  => false
      }
    end

    it "should return a Result object" do
      @result.should be_a ItemLookup::Result
    end

    %w(id name quality icon level slot heroic).each do |prop|
      it "should have a #{prop}" do
        @result.send(prop.intern).should eql(@expected[prop.intern])
      end
    end
  end
end