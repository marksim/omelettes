module Omelettes
  class Obfuscate
    class << self
      def cook
        Words.load(word_list || "/usr/share/dict/words")
        tables.each do |table|
          next if ignore_table?(table)
          print "\nProcessing #{model(table).name}"
          model(table).find_each do |object|
            model(table).columns.each do |column|
              next if ignore_column?(column.name) || column.type != :string
              object.obfuscate(column.name)
            end
            print "."
          end
        end
        print "\n"
      end

      def tables
        ActiveRecord::Base.connection.tables
      end

      def model(table)
        models ||= {}
        models[table] ||= table.camelcase.singularize.constantize
        models[table]
      end

      def ignore_table?(table)
        ignore_tables.each do |ignore|
          return true if table.match(ignore)
        end
        false
      end

      def ignore_column?(column)
        ignore_columns.each do |ignore|
          return true if column.match(ignore)
        end
        false
      end

      def obfuscate(string)
        return nil if string.nil?
        result = []
        string.split(/(\s+)|([[:punct:]])/).each do |word|
          result << (word.match(/[a-zA-Z]+/).nil? ? word : Words.replace(word))
        end
        result.join("")
      end

      attr_accessor :ignore_tables
      attr_accessor :ignore_columns
      attr_accessor :word_list
      attr_accessor :models
    end
  end
end