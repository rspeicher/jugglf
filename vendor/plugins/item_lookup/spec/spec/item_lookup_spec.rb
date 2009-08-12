require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

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
      @results.best_result.level.should == 25 # 5 * 5
    end
  
    it "should return nil when no results present" do
      @results = ItemLookup::Results.new
      @results.best_result.should be_nil
    end
  
    it "should return properly when one result present" do
      4.times { @results.shift }
      @results.length.should == 1
      @results.best_result.should == @results[0]
    end
  end
end

describe ItemLookup::Armory do
  it "should search wowarmory.com" do
    ItemLookup::Armory.should_receive(:search).with('Torch of Holy Fire', anything()).and_return(nil)
    ItemLookup.search('Torch of Holy Fire')
  end
  
  describe "when searching by id" do
    before(:all) do
      # First tooltip gets opened, then info
      ItemLookup::Armory.stub!(:open).and_return(
        File.read(File.dirname(__FILE__) + '/../fixtures/wowarmory/item-tooltip_40395.xml'),
        File.read(File.dirname(__FILE__) + '/../fixtures/wowarmory/item-info_40395.xml')
      )
      
      @result = ItemLookup.search('40395').best_result
      
      @expected = {
        :id      => 40395,
        :name    => 'Torch of Holy Fire',
        :quality => 4,
        :icon    => 'inv_mace_82',
        :level   => 226,
        :slot    => 'Main Hand'
      }
    end
    
    it "should return a valid Result object" do
      @result.should be_a ItemLookup::Result
      @result.should be_valid
    end
    
    %w(id name quality icon level slot).each do |prop|
      it "should have a #{prop}" do
        eval("@result.#{prop}").should == @expected[prop.intern]
      end
    end    
  end
  
  describe "when searching by name, multiple results" do
    before(:all) do
      ItemLookup::Armory.stub!(:open).and_return(
        File.read(File.dirname(__FILE__) + '/../fixtures/wowarmory/search_dark_matter.xml'),
        File.read(File.dirname(__FILE__) + '/../fixtures/wowarmory/item-tooltip_46038.xml')
      )
      @result = ItemLookup.search('Dark Matter').best_result
      
      @expected = {
        :id      => 46038,
        :name    => 'Dark Matter',
        :quality => 4,
        :icon    => 'spell_shadow_seedofdestruction',
        :level   => 226,
        :slot    => 'Trinket'
      }
    end
    
    %w(id name quality icon level slot).each do |prop|
      it "a result should have a #{prop}" do
        eval("@result.#{prop}").should == @expected[prop.intern]
      end
    end
  end
  
  describe "with no search results" do
    before(:each) do
      ItemLookup::Armory.stub!(:open).
        and_return(File.read(File.dirname(__FILE__) + '/../fixtures/wowarmory/search_no_results.xml'))
    end
    
    it "should return nil" do
      ItemLookup.search('Some Junk').should be_nil
    end
  end
end

describe ItemLookup::Wowhead do
  before(:each) do
    ItemLookup::Wowhead.stub!(:open).
      and_return(File.read(File.dirname(__FILE__) + '/../fixtures/wowhead/item_40395.xml'))
  end
  
  it "should search wowhead.com" do
    ItemLookup::Wowhead.should_receive(:search).with('40395', anything()).and_return(nil)
    ItemLookup.search('40395', :source => 'wowhead')
  end
  
  describe "results" do
    before(:all) do
      ItemLookup::Wowhead.stub!(:open).
        and_return(File.read(File.dirname(__FILE__) + '/../fixtures/wowhead/item_40395.xml'))
      @result = ItemLookup.search('40395', :source => 'wowhead').best_result
              
      @expected = {
        :id      => 40395,
        :name    => 'Torch of Holy Fire',
        :quality => 4,
        :icon    => 'INV_Mace_82',
        :level   => 226,
        :slot    => 'Main Hand'
      }
    end
    
    it "should return a Result object" do
      @result.should be_a ItemLookup::Result 
    end
    
    %w(id name quality icon level slot).each do |prop|
      it "should have a #{prop}" do
        eval("@result.#{prop}").should == @expected[prop.intern]
      end
    end
  end
end