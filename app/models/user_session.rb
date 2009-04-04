class UserSession < Authlogic::Session::Base
  authenticate_with InvisionUser
  last_request_at_threshold 1.minute
end