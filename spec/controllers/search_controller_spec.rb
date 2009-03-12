require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# -----------------------------------------------------------------------------
# Index
# -----------------------------------------------------------------------------

# GET /search/:context/:query
describe SearchController, "#index" do
  def get_response(type = :normal, params = {})
    params[:context] ||= 'members'
    params[:query]   ||= 'Name'
    
    if type == :normal
      get :index, params
    else
      xhr :get, :index, params
    end
  end
  
  describe "formats" do
    describe "HTML" do
      before(:each) do
        @member = mock_model(Member, :to_param => '1')
        Member.should_receive(:active).and_return(@member)        
      end
      
      it "should redirect to the object path for a single result" do
        @member.should_receive(:search).and_return([@member])

        get_response(:normal)
        response.should redirect_to(member_path(@member))
      end
      
      it "should render the context's index template for multiple results" do
        @member.should_receive(:search).and_return([@member, @member, @member])
        
        get_response
        response.should render_template('members/index')
      end
    end
    
    it "should return XML" do
      get_response(:normal, :format => 'xml')
      response.should be_success
    end
    
    it "should return JSON" do
      get_response(:xhr)
      response.should be_success
    end
  end
  
  describe "search members" do
    before(:each) do
      @member = mock_model(Member, :to_xml => nil)
      Member.should_receive(:active).and_return(@member)
    end
    
    it "should support field:value query" do
      @member.should_receive(:search).with(:order => 'name', :wow_class => '%Priest%').and_return(@member)
      get_response(:normal, :format => 'xml', :query => 'class:Priest')
    end
    
    it "should disallow invalid field queries" do
      @member.should_receive(:search).with(:order => 'name', :name => '%1%').and_return(@member)
      get_response(:normal, :format => 'xml', :query => 'attendance_30:1')
    end
  end
  
  describe "search items" do
    before(:each) do
      @items = [mock_model(Item, :name => 'ItemOne'), mock_model(Item, :name => 'ItemTwo')]
      Item.should_receive(:search).and_return(@items)
    end
    
    it "should return matching items" do
      get_response(:normal, :format => 'js', :context => 'items')
      assigns[:results].should == @items
    end
  end
end
