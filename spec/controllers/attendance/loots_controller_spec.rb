require 'spec_helper'

module AttendanceLootsHelperMethods
  def mock_find
    # This is a namespaced controller, so it always has a parent
    # We stub :loots to LiveLoot so that @parent.loots.find works as expected
    @parent ||= @live_raid ||= mock_model(LiveRaid, :loots => LiveLoot)
    LiveRaid.should_receive(:find).with(anything()).exactly(:once).and_return(@live_raid)
  
    # Check for at_most(:once) because update never finds a specific ID
    @live_loot ||= mock_model(LiveLoot)
    LiveLoot.should_receive(:find).with(anything()).at_most(:once).and_return(@live_loot)
  end
  
  def params(extras = {})
    {:live_raid_id => @parent.id, :id => @live_loot.id}.merge!(extras)
  end
end

describe Attendance::LootsController, "#update" do
  include AttendanceLootsHelperMethods
  
  before(:each) do
    login(:admin)
    mock_find
    LiveLoot.should_receive(:from_text).with('').and_return([])
  end
  
  describe "success" do
    before(:each) do
      @parent.stub!(:save).and_return(true)
      put :update, params(:live_loot => {:input_text => ''})
    end
    
    it { should_not set_the_flash }    
    it { should respond_with(:success) }
  end
  
  describe "failure" do
    before(:each) do
      @parent.stub!(:save).and_raise('Exception')
      put :update, params(:live_loot => {:input_text => ''})
    end
    
    it { should set_the_flash.to(/invalid/) }
    it { should respond_with(:success) }
  end
end

describe Attendance::LootsController, "#destroy" do
  include AttendanceLootsHelperMethods
  
  before(:each) do
    login(:admin)
    mock_find
    @live_loot.should_receive(:destroy)
    delete :destroy, params
  end
  
  it { should respond_with(:redirect) }
  it { should redirect_to(live_raid_path(@parent)) }
end