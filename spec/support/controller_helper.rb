module ControllerHelper
  # Instantiates object with the default Factory build for +var+, and expects any
  # calls to its parent class' +find+ method to return the Factory build.
  #
  # Example:
  #
  #   mock_find(:member) # => @object will be the result of Factory(:member), and Member.find will always return @object
  #   mock_find(:member, :name => 'NewName') # => Same as above, but sets an expectation on @object.name, and returns 'NewName'
  def mock_find(var, expects = {})
    @object ||= Factory(var)
    @object.class.should_receive(:find).with(anything()).exactly(:once).and_return(@object)
    
    expects.each_pair do |msg, val|
      @object.should_receive(msg).and_return(val)
    end
  end

  # Instantiates object with the default Factory build for +var+, and expects any
  # calls to its parent class' +new+ method to return the Factory build.
  #
  # Example:
  #
  #   mock_create(:member) # => @object will be the result of Factory(:member), and Member.new will always return @object
  #   mock_create(:member, :save => false) # => Same as above, but sets an expectation on @object.save, and returns false
  def mock_create(var, expects = {})
    @object ||= Factory(var)
    @object.class.should_receive(:new).with(anything()).exactly(:once).and_return(@object)
    
    expects.each_pair do |msg, val|
      @object.should_receive(msg).and_return(val)
    end
  end
end