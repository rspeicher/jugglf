module ControllerHelper
  # Instantiates +@parent+ with the default Factory build for +var+, and expects any
  # calls to its parent class' +find+ method to return the Factory build.
  #
  # Example:
  #
  #   mock_parent(:member) # => @parent will be the result of Factory(:member), and Member.find will always return @parent
  #   mock_parent(:member, :name => 'NewName') # => Same as above, but sets an expectation on @parent.name, and returns 'NewName'
  def mock_parent(var, expects = {})
    @parent ||= Factory(var)
    @parent.class.should_receive(:find).and_return(@parent)
    
    expects.each_pair do |msg, val|
      @parent.should_receive(msg).and_return(val)
    end
    
    self.instance_variable_set("@#{var.to_s.underscore}", @parent) unless self.instance_variables.include? "@#{var.to_s.underscore}"
  end
  
  # Instantiates +@object+ with the default Factory build for +var+, and expects any
  # calls to its parent class' +find+ method to return the Factory build.
  #
  # Example:
  #
  #   mock_find(:member) # => @object will be the result of Factory(:member), and Member.find will always return @object
  #   mock_find(:member, :name => 'NewName') # => Same as above, but sets an expectation on @object.name, and returns 'NewName'
  def mock_find(var, expects = {})
    unless @parent.nil?
      @object ||= Factory(var, @parent.class.to_s.underscore.to_sym => @parent)
    else
      @object ||= Factory(var)
    end
    @object.class.should_receive(:find).and_return(@object)
    
    expects.each_pair do |msg, val|
      @object.should_receive(msg).and_return(val)
    end
    
    self.instance_variable_set("@#{var.to_s.underscore}", @object) unless self.instance_variables.include? "@#{var.to_s.underscore}"
  end

  # Instantiates +@object+ with the default Factory build for +var+, and expects any
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
    
    self.instance_variable_set("@#{var.to_s.underscore}", @object) unless self.instance_variables.include? "@#{var.to_s.underscore}"
  end
end