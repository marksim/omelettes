module Omelettes
  module ModelAdditions
    module ClassMethods
      def column_config(column_name)
        @column_config ||= {}
        @column_config[column_name.to_s]
      end
      
      def treat(column_name, style=nil, &block)
        @column_config ||= {}
        column = Column.new(column_name, style, &block)
        @column_config[column_name.to_s] = column
        column
      end
      alias :scramble :treat
      
      def ignore(column_name)
        @column_config ||= {}
        column = Column.new(column_name, :hardened)
        @column_config[column_name.to_s] = column
        column
      end
      alias :harden :ignore
    end

    def obfuscate(column_names)
      attributes = {}
      column_names.each do |column_name|
        column = self.class.column_config(column_name)
        original_value = self.send(column_name)
        if column
          value = column.process(original_value)
        else
          value = Column.default(column_name, original_value)
        end
        attributes[column_name] = value
      end
      self.class.where(:id => self.id).update_all(attributes)
    end

    def self.included(base)
      base.extend ClassMethods
    end
  end
end

ActiveRecord::Base.class_eval do
  include Omelettes::ModelAdditions
end
