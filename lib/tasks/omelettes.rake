namespace :db do
  desc "Obfuscate the database with Omelettes"
  task :cook => :environment do
    print "Are you sure you want to scramble all strings in the database? (y/n): "
    input = $stdin.gets.strip
    if input == "y"
      Omelettes::Obfuscate.cook
    end
  end
end