require 'spec_helper'

describe Omelettes::Obfuscate do

  describe "models" do 
    it "allows for override" do
      Omelettes.setup do |config|
        config.models['logins'] = User
      end

      Omelettes::Obfuscate.model("logins").should == User
    end

    it "returns the model" do
      Omelettes::Obfuscate.model("users").should == User
    end
  end

  describe "ignore tables" do
    it "ignores matching strings" do
      Omelettes.setup do |config|
        config.ignore_tables = ["alpha", "beta", "kappa"]
      end

      Omelettes::Obfuscate.ignore_table?("alpha").should be_true
      Omelettes::Obfuscate.ignore_table?("beta").should be_true
      Omelettes::Obfuscate.ignore_table?("kappa").should be_true
      Omelettes::Obfuscate.ignore_table?("delta").should be_false
    end

    it "ignores matching regex" do
      Omelettes.setup do |config|
        config.ignore_tables = [/[a-z_]*type/i]
      end

      Omelettes::Obfuscate.ignore_table?("type").should be_true
      Omelettes::Obfuscate.ignore_table?("my_favorite_type").should be_true
      Omelettes::Obfuscate.ignore_table?("matype").should be_true
      Omelettes::Obfuscate.ignore_table?("typedef").should be_false
      Omelettes::Obfuscate.ignore_table?("another").should be_false
    end
  end

  describe "ignore columns" do
    it "ignores matching strings" do
      Omelettes.setup do |config|
        config.ignore_columns = ["alpha", "beta", "kappa"]
      end

      Omelettes::Obfuscate.ignore_column?("alpha").should be_true
      Omelettes::Obfuscate.ignore_column?("beta").should be_true
      Omelettes::Obfuscate.ignore_column?("kappa").should be_true
      Omelettes::Obfuscate.ignore_column?("delta").should be_false
    end

    it "ignores matching regex" do
      Omelettes.setup do |config|
        config.ignore_columns = [/[a-z_]*type/i]
      end

      Omelettes::Obfuscate.ignore_column?("type").should be_true
      Omelettes::Obfuscate.ignore_column?("my_favorite_type").should be_true
      Omelettes::Obfuscate.ignore_column?("matype").should be_true
      Omelettes::Obfuscate.ignore_column?("typedef").should be_false
      Omelettes::Obfuscate.ignore_column?("another").should be_false
    end
  end

  describe "obfuscate" do
    it "returns nil if passed nil" do
      Omelettes::Obfuscate.obfuscate(nil).should be_nil
    end

    it "replaces words" do
      Omelettes::Words.clear
      ["barfs", "foo", "queen", "tad"].each do |word|
        Omelettes::Words.add(word)
      end
      Omelettes::Obfuscate.obfuscate("the quick brown fox").should == "tad queen barfs foo"
    end

    it "preserves punctuation" do
      Omelettes::Words.clear
      ["barfs", "foo", "queen", "tad"].each do |word|
        Omelettes::Words.add(word)
      end
      Omelettes::Obfuscate.obfuscate("the: quick, brown! fox :)").should == "tad: queen, barfs! foo :)"
    end

    it "preserves digits" do
      Omelettes::Words.clear
      ["barfs", "foo", "queen", "tad"].each do |word|
        Omelettes::Words.add(word)
      end
      Omelettes::Obfuscate.obfuscate("the: 1quick, 1504brown! fox :)").should == "tad: 1queen, 1504barfs! foo :)"
    end
  end

  describe "cook" do
    before(:each) do
      Omelettes.setup do |config|
        config.word_list = %w(barfs foo queen tad pole)
      end

      Omelettes::Obfuscate.stub(:tables).and_return(["users"])

      User.stub(:find_each).and_return(User.new(:first_name => "Mark", :last_name => "Sim", :city => "Austin"))
    end

    it "ignores specified tables" do
      Omelettes::Obfuscate.ignore_tables = ["users"]
      Omelettes::Obfuscate.cook(true).should == [0, 0]
    end

    it "ignores specified columns" do
      Omelettes::Obfuscate.ignore_tables = []
      Omelettes::Obfuscate.ignore_columns = ['first_name', 'middle_name', 'last_name', 'city']
      Omelettes::Obfuscate.cook(true).should == [1, 0]
    end
  end
end