module Omelettes
  class Words
    class << self

      def word_hash
        @word_hash ||= {}
      end

      def add(word)
        key = "#{word[0,1].downcase}#{word.length}"
        @word_hash[key] ||= []
        @word_hash[key] << word
      end

      def replace(word)
        key = "#{word[0,1].downcase}#{word.length}"
        valid_words = (@word_hash[key] || [])
        new_word = valid_words[rand(valid_words.size)]
        return new_word.send(word[0,1].upcase == word[0,1] ? :capitalize : :downcase) unless new_word.nil?
        word
      end

      def load(path="/usr/share/dict/words")
        clear
        (path.is_a?(Array) ? path : File.readlines(path)).each do |word|
          add(word.strip)
        end
      end

      def clear
        @word_hash = {}
      end
    end
  end

end