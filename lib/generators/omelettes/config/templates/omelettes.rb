# Omelettes Obfuscation Setup
#
# Ignore tables or columns using strings or regular expressions
#   config.ignore_tables = ["schema_migrations", "my_reporting_table", /(a-z_)user/]
#   config.ignore_columns = [/(a-z_)*type/i, "name", "city"]
#
# Override non-standard table names => classes like this
#   config.models['admin_users'] = Admin::User

Omelettes.setup do |config|
  config.ignore_columns = [/(a-z_)*type/i]
  config.ignore_tables  = ['schema_migrations']
end