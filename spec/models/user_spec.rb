require 'spec_helper'

describe User do
  before(:each) do
    @attr = {:name => "Example User", :email => "user@example.com"}
  end
  it "Should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  it "Should require a name" do
    no_name_user = User.new(@attr.merge(:name => "", ))
    no_name_user.should_not be_valid
  end
  it "should reject names that are too long" do
    long_name_user = User.new(@attr.merge(:name => "a"*51))
    long_name_user.should_not be_valid
  end
  it "should accept valid email ids" do
    addresses = %w[me@gmail.com THE_USER@some.mail.com first.last@foo.jp a+b@gmail.com]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  it "should reject invalid email ids" do
    addresses = %w[me@gmail,com THE_USER.com last@foo @gmail.com]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  it "should reject duplicate email addresses" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email, ))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid 
  end
  
  
  
  
end
