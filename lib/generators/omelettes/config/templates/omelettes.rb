# Omelettes Obfuscation Setup
#
# Columns with the following names will be automatically Faker-ified.  
# You can make columns with other names Faker-ified by overriding the model
#   specific columns a la:  User.scramble(:nickname).as(:first_name)
#   
#     :name, :first_name, :last_name
#     :city, :state, :country, :street_address, :street_name, :zip_code
#     :company_name, :company, :email, :user_name, :phone
#     :paragraph, :paragraphs, :sentence, :sentences, :words

Omelettes.setup do |config|
  # Ignore tables or columns using strings or regular expressions
  #   config.ignore_tables = ["schema_migrations", "my_reporting_table", /(a-z_)user/]
  #   config.ignore_columns = [/(a-z_)*type/i, "name", "city"]

  config.ignore_columns = [/[a-z_]*type/i, /[a-z_]*password[a-z_]*/i]
  config.ignore_tables  = ['schema_migrations']

  # Override non-standard table names => classes like this
  #   config.models['admin_users'] = Admin::User
  
  # Override model specific columns
  #   User.scramble(:nickname).as(:name)
  #   Person.scramble(:street) {|value| "#{value.reverse}"}
  # Freeze / Ignore columns on specific models
  #   User.harden(:password)
  # To make a normally "Faker" obfuscated column behave normally, override with :omelette
  #   User.scramble(:name).as(:omelette)
end