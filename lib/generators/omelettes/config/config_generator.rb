module Omelettes
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def generate_config
        copy_file "omelettes.rb", "config/initializers/omelettes.rb"
      end
    end
  end
end