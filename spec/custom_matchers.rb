require 'login_helper'

module AuthorizationMatchers
  
  # Ensures that ...
  #
  # Example:
  #
  def allow_access_to(method, action, params = {})
    AllowAccessToMatcher.new(method, action, params, self)
  end
  
  class AllowAccessToMatcher # :nodoc:
    include LoginHelper
    
    def initialize(method, action, params, context)
      @method  = method
      @action  = action
      @params  = params
      @context = context
    end
    
    def as(user)
      @user = user
      self
    end
    
    def matches?(controller)
      @controller = controller
      allows_access?
    end
    
    attr_reader :failure_message, :negative_failure_message
    
    def description
      "allow access to #{@method.to_s.upcase} #{@action.to_s.downcase} as #{@user.to_s}"
    end
    
    private
      def allows_access?
        # login(@user)
        @context.send(@method, @action, @params)
        
        if @controller.response.response_code == 200
          @negative_failure_message = "Should not #{description}, but did"
          true
        else
          @failure_message = "Should #{description}, but didn't"
          false
        end
      end
      
      # def allowed_access?
      #   # All permission denied errors get set via flash[:error]
      #   if flash.blank? or flash[:error].blank?
      #     true
      #   else
      #     if flash[:error] =~ /do not have permission to access/ or flash[:error] =~ /must be logged in to access/
      #       false
      #     else
      #       true
      #     end
      #   end
      # end
      
      # def flash
      #   @controller.response.session['flash']
      # end
  end
end