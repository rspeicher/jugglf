require 'spec_helper'

describe Attendance::LootsController, "#update" do
  before do
    @parent   = Factory(:live_raid_with_loot)
    @resource = @parent.loots.first

    LiveRaid.expects(:find).returns(@parent)
    LiveLoot.expects(:from_text).with('').returns([])
  end

  describe "success" do
    context "xhr" do
      before do
        @parent.expects(:save!).returns(true)
        xhr :post, :update, :live_raid_id => @parent, :id => @resource, :live_loot => {:input_text => ''}
      end

      it { should_not set_the_flash }
      it { should respond_with(:success) }
      it { should render_template(:update) }
    end

    context "js" do
      before do
        @parent.expects(:save!).returns(true)
        put :update, :format => 'js', :live_raid_id => @parent, :id => @resource, :live_loot => {:input_text => ''}
      end

      it { should_not set_the_flash }
      it { should respond_with(:success) }
      it { should render_template(:update) }
    end
  end

  describe "failure" do
    context "xhr" do
      before do
        @parent.expects(:save!).raises(RuntimeError)
        xhr :post, :update, :live_raid_id => @parent, :id => @resource, :live_loot => {:input_text => ''}
      end

      it { should set_the_flash.to(/loot entry was invalid/) }
      it { should respond_with(:success) }
      it { should render_template(:update) }
    end

    context "js" do
      before do
        @parent.expects(:save!).raises(RuntimeError)
        put :update, :format => 'js', :live_raid_id => @parent, :id => @resource, :live_loot => {:input_text => ''}
      end

      it { should set_the_flash.to(/loot entry was invalid/) }
      it { should respond_with(:success) }
      it { should render_template(:update) }
    end
  end
end

describe Attendance::LootsController, "#destroy" do
  before do
    @parent   = Factory(:live_raid_with_loot)
    @resource = @parent.loots.first
    @resource.expects(:destroy)

    LiveRaid.any_instance.stubs(:loots).returns(stub(:find => @resource))

    delete :destroy, :live_raid_id => @parent, :id => @resource
  end

  it { should respond_with(:redirect) }
  it { should redirect_to(live_raid_path(@parent)) }
end
