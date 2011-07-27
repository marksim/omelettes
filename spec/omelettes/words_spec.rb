require 'spec_helper'

describe Omelettes::Words do
  describe "load" do
    it "loads from the default path" do
      Omelettes::Words.clear
      Omelettes::Words.word_hash.should == {}
      Omelettes::Words.load
      Omelettes::Words.word_hash.should_not == {}
      Omelettes::Words.word_hash.should_not be_nil

    end

    it "optionally accepts a load path" do
      File.should_receive(:readlines).once.and_return(["one"])
      Omelettes::Words.load("test.path")
      Omelettes::Words.word_hash.should == {"o3" => ["one"]}
    end
  end

  describe "add" do
    before(:each) do
      Omelettes::Words.clear
    end
    it "adds a word to the values of the word_hash" do
      Omelettes::Words.add("fate")
      Omelettes::Words.word_hash.values.flatten.should include("fate")
    end

    it "indexes based on word length and first letter" do
      Omelettes::Words.add("tony")
      Omelettes::Words.word_hash["t4"].should include("tony")
    end

    it "does not care the case" do
      Omelettes::Words.add("FaT")
      Omelettes::Words.word_hash["f3"].should include("FaT")
    end
  end

  describe "replace" do
    before(:each) do
      Omelettes::Words.clear
    end

    it "returns a word of the same length" do
      Omelettes::Words.add("bra")
      Omelettes::Words.add("brak")
      Omelettes::Words.add("brake")

      Omelettes::Words.replace("bat").should == "bra"
    end

    it "returns a word starting with the same letter" do
      Omelettes::Words.add("abc")
      Omelettes::Words.add("bcd")
      Omelettes::Words.add("cde")

      Omelettes::Words.replace("att").should == "abc"
    end

    it "returns itself if there is no word in the dictionary matching the first letter and length" do
      Omelettes::Words.add("bra")
      Omelettes::Words.add("cake")
      Omelettes::Words.add("brake")

      Omelettes::Words.replace("bork").should == "bork"
    end
  end
end