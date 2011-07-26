require 'rubygems'
require 'omelettes'

RSpec.configure do |config|
end

class TablelessModel < ActiveRecord::Base
  def self.columns() @columns ||= []; end
 
  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end

end

class User < TablelessModel
  column :first_name, :last_name, :city
end

