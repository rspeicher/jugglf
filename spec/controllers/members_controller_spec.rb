require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MembersController, "POST /members" do
  before(:each) do
    @mock = mock_model(Member, :to_param => '1', :save => true)
    @plan = Member.plan.stringify_keys!
  end
  
  def do_post
    post :create, :member => @plan
  end
  
  it "should create a new member from params" do
    Member.should_receive(:new).with(@plan).and_return(@mock)
    do_post
  end
  
  describe "when successful" do
    before(:each) do
      Member.should_receive(:new).with(@plan).and_return(@mock)
    end
    
    it "should add a flash success message" do
      do_post
      flash[:success].should == 'Member was successfully created.'
    end
    
    it "should redirect to the new member" do
      do_post
      response.should redirect_to(member_url('1'))
    end
  end
  
  describe "when unsuccessful" do
    before(:each) do
      @mock = mock_model(Member, :save => false)
      Member.stub!(:new).and_return(@mock)
    end
    
    it "should render template :new" do
      do_post
      response.should render_template(:new)
    end
  end
end