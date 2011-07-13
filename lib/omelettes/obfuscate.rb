module Omelettes
  def self.setup
    yield Omelettes::Obfuscate
  end

  class Obfuscate
    class << self
      def cook
        Words.load(word_list || "/usr/share/dict/words")
        tables.each do |table|
          next if ignore_table?(table)
          model(table).find_each do |object|
            model(table).columns.each do |column|
              next if ignore_column?(column.name) || column.type != :string
              object.update_attribute(column.name, obfuscate(object.send(column.name)))
            end
          end
        end
      end

      def tables
        ActiveRecord::Base.connection.tables
      end

      def model(table)
        table.camelcase.singularize.constantize
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
        result = []
        string.split(/(\s+)|([[:punct:]])/).each do |word|
          result << (word.match(/[a-zA-Z]+/).nil? ? word : Words.get(word))
        end
        result.join("")
      end

      attr_accessor :ignore_tables
      attr_accessor :ignore_columns
      attr_accessor :word_list
    end
  end

  class Words
    class << self

      def word_hash
        @word_hash ||= {}
      end

      def add(word)
        key = "#{word[0].downcase}#{word.length}"
        @word_hash[key] ||= []
        @word_hash[key] << word
      end

      def get(word)
        key = "#{word[0].downcase}#{word.length}"
        valid_words = (@word_hash[key] || [])
        valid_words[rand(valid_words.size)].send(word[0].upcase == word[0] ? :capitalize : :downcase)
      end

      def load(path="/usr/share/dict/words")
        @word_hash = {}
        File.readlines(path).each do |word|
          add(word.strip)
        end
      end
    end
  end

end