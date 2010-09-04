InvisionBridge.setup do |config|
  config.database_file = "#{Rails.root}/config/database.yml"
  config.environment   = Rails.env
end
