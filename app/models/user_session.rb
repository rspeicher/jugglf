class UserSession < Authlogic::Session::Base
  last_request_at_threshold 1.minute
  params_key 'api_key'

  def to_key
    new_record? ? nil : [ self.send(self.class.primary_key) ]
  end
end
