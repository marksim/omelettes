require 'spec_helper'

describe Omelettes::Column do
  describe "creation" do
    it "accepts a name" do
      c = nil
      lambda { c = Omelettes::Column.new(:name) }.should_not raise_error
      c.name.should == :name
    end

    it "accepts a name and an optional style" do
      c = nil
      lambda { c = Omelettes::Column.new(:name, :city) }.should_not raise_error
      c.name.should == :name
      c.style.should == :city
    end

    it "accepts a block" do
      c = Omelettes::Column.new(:name) {|value| value.reverse}
      c.custom_block.should_not be_nil
    end

    it "allows 'as' or 'like' syntax to alter the style" do
      Omelettes::Column.new(:name).as(:test).style.should == :test
      Omelettes::Column.new(:value).like(:key).style.should == :key
    end
  end

  describe "process" do
    it "executes a block if present" do
      c = Omelettes::Column.new(:name) {|value| value.reverse}
      c.process("eggs").should == "sgge"
    end

    it "calls the default processing method if no block present" do
      c = Omelettes::Column.new(:name)
      Faker::Name.should_receive(:name).once
      c.process("Mark")
    end

    it "calls the passed 'style' if passed, overriding the name" do
      c = Omelettes::Column.new(:name).as(:paragraph)
      Faker::Lorem.should_receive(:paragraph).once
      c.process("Some stuff")
    end

    it "calls the standard obfuscation method if the style is not recognized" do
      c = Omelettes::Column.new(:name).as(:omelettes)
      Omelettes::Obfuscate.should_receive(:obfuscate).once
      c.process("Some Stuff")
    end
  end
end