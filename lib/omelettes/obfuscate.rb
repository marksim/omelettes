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
            table.columns.each do |column|
              next if ignore_column?(column)
              object.update_attribute(column, obfuscate(object.send(column)))
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

      def obfuscate(string)
        result = []
        string.split(/(s+)|([[:punct:]])/).each do |word|
          result << word.match(/[a-zA-Z]+/).nil? ? word : Words.get(word)
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
        valid_words[rand(valid_words.size)]
      end

      def load(path="/usr/share/dict/words")
        File.readlines(path).each do |word|
          add(word)
        end
      end
    end
  end

end