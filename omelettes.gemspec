Gem::Specification.new do |s|
  s.name        = "omelettes"
  s.version     = "0.2.0"
  s.author      = "Mark Sim"
  s.email       = "mark@quarternotecoda.com"
  s.homepage    = "http://github.com/marksim/omelettes"
  s.summary     = "Database obfuscation."
  s.description = "Low-to-no configuration solution for obfuscating sensitive data in your database."

  s.files        = Dir["{lib,spec}/**/*", "[A-Z]*", "init.rb"] - ["Gemfile.lock"]
  s.require_path = "lib"

  s.add_development_dependency 'rspec', '~> 2.1.0'
  s.add_dependency 'faker', "~> 0.9.5"
  s.add_dependency 'activerecord', '~> 3.0'

  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
end
