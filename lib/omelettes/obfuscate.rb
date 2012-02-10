module Omelettes
  class Obfuscate
    class << self
      def cook(silent=false)
        total_tables = 0
        total_attributes = 0
        Words.load(word_list || "/usr/share/dict/words")
        processed = []
        tables.each do |table|
          next if ignore_table?(table)
          processed << table
          pbar = ProgressBar.new(model(table).name, model(table).count) unless silent
          model(table).find_each do |object|
            begin
              object.obfuscate(columns_for_table(table))
              total_attributes += 1
            rescue => e
              puts e.message
              next
            ensure
              pbar.inc unless silent
            end
          end
          pbar.finish unless silent
          total_tables += 1
        end
        if @callback
          @callback.call
        end
        unless silent
          puts " Obfuscation Report (the following tables and columns were processed)"
          puts ("----------" * 8)
          processed.each do |table|
            label = model(table).name
            columns_for_table(table).join(',').scan(/.{0,60}/).each do |columns|
              puts "%20.20s | %-60.60s" % [label, columns] unless columns.blank?
              label = ""
            end
          end
        end

        [total_tables, total_attributes]
      end

      def tables
        ActiveRecord::Base.connection.tables
      end

      def model(table)
        self.models ||= {}
        self.models[table] ||= table.camelcase.singularize.constantize
        self.models[table]
      end

      def ignore_table?(table)
        ignore_tables.each do |ignore|
          return true if table.match(ignore).to_s == table
        end
        return true unless columns_for_table(table).any?
        return true if model(table).count == 0
        false
      end

      def ignore_column?(column)
        ignore_columns.each do |ignore|
          return true if column.match(ignore).to_s == column
        end
        false
      end

      def columns_for_table(table)
        @columns_for_table ||= {}
        @columns_for_table[table] ||= model(table).columns.select {|column| !ignore_column?(column.name) && (column.type == :string || column.type == :text)}.map(&:name)
      end

      def cleanup(&callback)
        @callback = callback
      end

      def obfuscate(string)
        return nil if string.nil?
        string.split(/(\s+)|([[:punct:]])/).map do |word|
          word.match(/[a-zA-Z]+/).nil? ? word : Words.replace(word)
        end.join("")
      end

      attr_accessor :ignore_tables
      attr_accessor :ignore_columns
      attr_accessor :word_list
      attr_accessor :models
    end
  end
end