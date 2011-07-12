namespace :db do
  desc "Obfuscate the database with Omelettes"
  task :cook => :environment do
    Omelettes::Obfuscate.cook
  end
end