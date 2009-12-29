class UserSession < Authlogic::Session::Base
  authenticate_with User
  last_request_at_threshold 1.minute
  params_key 'api_key'
end