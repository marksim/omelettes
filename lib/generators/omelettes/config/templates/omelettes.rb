# Omelettes Obfuscation Setup
#
Omelettes.setup do |config|
  config.ignore_columns = [/(a-z_)?type/i]
  config.ignore_tables  = ['schema_migrations']
end