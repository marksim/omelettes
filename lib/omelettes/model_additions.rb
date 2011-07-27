require 'faker'

module Omelettes
  module ModelAdditions
    module ClassMethods
      def column_config(column_name)
        @column_config ||= {}
        @column_config[column_name.to_s]
      end
      
      def treat(column_name, style=nil)
        @column_config ||= {}
        column = Column.new(column_name, style)
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

    def obfuscate(column_name)
      column = self.class.column_config(column_name)
      if column
        value = column.process(self.send(column_name))
      else
        value = Column.default(column_name, self.send(column_name))
      end
      self.update_attribute(column_name, value)
    end

    def self.included(base)
      base.extend ClassMethods
    end
  end

  class Column
    attr_accessor :name, :style, :custom_block
    def initialize(name, style=nil, &block)
      @name = name
      @style = style
      @custom_block = block
    end

    def process(string)
      if @custom_block
        return @custom_block.call(string)
      else
        Column.default(@style, string)
      end
    end

    def self.default(name, value)
      name = name.downcase.to_sym
      case name
      when :hardened
        return value
      when :name, :first_name, :last_name
        return Faker::Name.send(name)
      when :city, :state, :country, :street_address, :street_name, :zip_code
        return Faker::Address.send(name)
      when :company_name, :company
        return Faker::Company.name
      when :email, :user_name
        return Faker::Internet.send(name)
      when :paragraph, :paragraphs, :sentence, :sentences, :words
        return Faker::Lorem.send(name)
      when :phone
        return Faker::PhoneNumber.phone_number
      else
        return Omelettes::Obfuscate.obfuscate(value)
      end
    end

    def as(style)
      @style = style unless @style == :hardened
    end
    alias :like :as
  end
end

ActiveRecord::Base.class_eval do
  include Omelettes::ModelAdditions
end
