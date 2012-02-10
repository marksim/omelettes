require 'faker'

module Omelettes
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
        Column.default(@style || @name, string)
      end
    end

    def self.default(name, value)
      name = name.downcase.to_sym
      case name
      when :hardened
        return value
      when :first_name, :last_name
        return Faker::Name.send(name)
      when :city, :state, :country, :street_address, :street_name, :zip_code
        return Faker::Address.send(name)
      when :company_name, :company
        return Faker::Company.name
      when :email, :user_name
        return Faker::Internet.send(name)
      when :paragraph, :paragraphs, :sentence, :sentences, :words
        return Faker::Lorem.send(name)
      when :phone, :contact_phone, :fax
        return Faker::PhoneNumber.phone_number
      when :url, :website
        return Faker::Internet.domain_name
      else
        return Omelettes::Obfuscate.obfuscate(value)
      end
    end

    def as(style)
      @style = style unless @style == :hardened
      self
    end
    alias :like :as
  end
end