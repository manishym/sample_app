require 'spec_helper'

describe User do
  before(:each) do
    @attr = {
      :name => "Example User",
      :email => "user@example.com",
      :password => "foobar", 
      :password_confirmation => "foobar", 
       }
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
  describe "password validations" do 
    
    it "should require a password" do
      User.new(@attr.merge(:password => "",:password_confirmation => "" )).
      should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "value")).
      should_not be_valid
    end
    
    it "should reject short passwords" do
      short="a"*5
      hash=@attr.merge(:password => short, :password_confirmation => short )
      user = User.new( hash )
      user.should_not be_valid
    end
    it "should reject long passwords" do
      long_pwd="b"*41
      hash=@attr.merge(:password => long_pwd, :confirmation => long_pwd)
      User.new(hash).should_not be_valid
    end
      
  
  end
  describe "encrypted passwords" do
    before(:each) do
      @user = User.create!(@attr)
    end
    it "should have an encrypted password attribute"  do
      @user.should respond_to(:encrypted_password)
    end
    it "should set the encrypted password" do
          @user.encrypted_password.should_not be_blank
    end
    describe "has_password? method" do 
      it "should be true if passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      it "Should be false if the passwords do not match" do
        @user.has_password?("invalid").should_not be_true
      end
      describe "Authenticate method" do
        it "should return nil if email/password mismatch" do
          wrong_user = User.authenticate(@attr[:email], "wrong_password")
          wrong_user.should be_nil
        end
        it "should return nil if email does not exist" do
          non_existant_user = User.authenticate("bar@foo.com", @attr[:encrypted_password])
          non_existant_user.should be_nil
        end
        it "should return true if email password match" do
          correct_user = User.authenticate(@attr[:email], @attr[:password])
        end
      end
      
    end
    
  end
    
  
  
end
