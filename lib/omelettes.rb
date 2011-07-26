begin
  require 'active_record'
rescue LoadError
  require 'activerecord' unless defined?(ActiveRecord)
end

require 'omelettes/model_additions'
require 'omelettes/obfuscate'
require 'omelettes/words'

module Omelettes
  require 'omelettes/railtie' if defined?(Rails)

  def self.setup
    yield Omelettes::Obfuscate
  end
end