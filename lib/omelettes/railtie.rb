require 'omelettes'
require 'rails'

module Omelettes
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/omelettes.rake"
    end
  end
end
