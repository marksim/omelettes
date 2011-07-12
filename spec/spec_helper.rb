require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

# require 'supermodel' # shouldn't Bundler do this already?
require 'active_support/all'

RSpec.configure do |config|
  config.mock_with :rr
end

