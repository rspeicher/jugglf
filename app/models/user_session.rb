class UserSession < Authlogic::Session::Base
  authenticate_with InvisionUser
end