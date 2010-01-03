module Juggernaut
  def self.[](key)
    unless @config
      raw_config = File.read(RAILS_ROOT + "/config/juggernaut.yml")
      @config = YAML.load(raw_config)[RAILS_ENV].symbolize_keys
    end
    @config[key]
  end
  
  def self.[]=(key, value)
    @config[key.to_sym] = value
  end
end