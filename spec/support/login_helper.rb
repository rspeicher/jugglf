require 'authlogic'
require 'authlogic/test_case'

module LoginHelper
  include Authlogic::TestCase

  def login(type = :user, args = {})
    unless type == :guest
      type = :user unless type == :admin

      activate_authlogic
      UserSession.create(Factory(type))
    end
  end

  def logout
    UserSession.find.try(:destroy)
  end
end
