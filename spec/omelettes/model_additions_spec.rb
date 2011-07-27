require 'spec_helper'

describe "Model Additions" do
  describe "treat / scramble" do
    it "should create a column with a specified style for a model" do
      User.treat(:middle_name).as(:first_name)
      User.column_config(:middle_name).style.should == :first_name
    end

    it "should create a column with a custom block specified for a model" do
      User.scramble(:middle_name) {|value| value.reverse}
      User.column_config(:middle_name).custom_block.should_not be_nil
    end
  end

  describe "ignore / harden" do
    it "should create a column with a style of ':hardened'" do
      User.ignore(:middle_name)
      User.column_config(:middle_name).style.should == :hardened
    end

    it "should not be overwritten with 'as'" do
      User.ignore(:middle_name).as(:first_name)
      User.column_config(:middle_name).style.should == :hardened
    end
  end

  describe "obfuscate" do
    before(:each) do
      @user = User.new
      @user.stub(:first_name).and_return("Ed")
      @user.stub(:middle_name).and_return("Jeremy")
      @user.stub(:last_name).and_return("Stevens")
      @user.stub(:city).and_return("Stuckeyville")
      User.stub(:find_each).and_return([@user])
    end

    it "should process the column result back to the database" do
      User.treat(:middle_name).as(:first_name)
      @user.should_receive(:update_attribute).once
      @user.obfuscate(:middle_name)
    end

    it "should not write anything to the database if the column is ignored" do
      User.ignore(:city)
      @user.should_not_receive(:update_attribute)
      @user.obfuscate(:city)
    end

    it "should call the passed block and write the result to the database" do
      User.treat(:last_name) {|value| "Vessy"}
      @user.should_receive(:update_attribute).with(:last_name, "Vessy").once
      @user.obfuscate(:last_name)
    end

    it "should call Faker for default column names, even if not explicitly configured" do
      Faker::Name.should_receive(:first_name).once
      @user.should_receive(:update_attribute).once
      @user.obfuscate(:first_name)
    end
  end
end