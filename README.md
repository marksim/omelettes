# Omelettes #

## Basic Usage ##

    gem install omelettes
    rails g omelettes:config
    rake db:cook

## Configuration ##

  After running 'rails g omelettes:config' you will find a config file in 'config/initializers/omelettes.rb'

    Omelettes.setup do |config|
      # Ignore tables or columns using strings or regular expressions
      config.ignore_tables = ["schema_migrations", "my_reporting_table", /(a-z_)user/]
      config.ignore_columns = [/(a-z_)*type/i, "name", "city"]
      
      # Override non-standard table names => classes like this
      #   config.models['admin_users'] = Admin::User
      
      # Override model specific columns
      
      User.treat(:nickname).as(:name)
      Person.scramble(:street) {|value| "#{value.reverse}"}
      
      # Freeze / Ignore columns on specific models
      User.harden(:password)
      
      # To make a normally "Faker" obfuscated column behave normally, override with :omelette
      User.scramble(:name).as(:omelette)

      # To override the model associated with a specific table, make sure and specify it here:
      config.models['logins'] = User
    end

By default, the following columns will be Faker-ified (replaced with faker info RATHER than obfuscated using omelettes same-length-and-initial-character)

* name
* first_name
* last_name
* city 
* state
* country
* street_address
* street_name
* zip_code
* company_name
* company
* email
* user_name
* phone

And the following can be used to 'treat' a column 'as':
* paragraph 
* paragraphs 
* sentence 
* sentences 
* words

You can also keep model-level configurations within the model itself

    class User < ActiveRecord::Base
      treat(:login).as(:user_name)
      ignore :password
    end

## About ##

omelettets is obfuscated 'obfuscate'.   Omelettes takes strings in your database and replaces them with worlds of the same length and same initial letter.
