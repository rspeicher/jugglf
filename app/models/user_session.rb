class UserSession < Authlogic::Session::Base
  authenticate_with InvisionBridge::InvisionUser
  last_request_at_threshold 1.minute
  params_key 'api_key'
end