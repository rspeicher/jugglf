InvisionBridge.setup do |config|
  config.database_file = Rails.configuration.database_configuration_file
  config.environment   = Rails.env
end
