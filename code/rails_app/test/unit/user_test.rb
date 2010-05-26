require 'test_helper'

class UserTest < ActiveSupport::TestCase
        
  setup do
    @valid_attributes = { 
        :username => "bigsaver",
        :email    => 'bigsaver@saveup.com', 
        :password => 'secret', 
        :password_confirmation => 'secret'
      }
    
    @user = User.new(@valid_attributes)
  end
  
  test "create with valid attributes should save record" do
    assert_difference 'User.count', 1 do
      user = User.create(@valid_attributes)
      assert !user.new_record?
    end
  end
  
  test "should require valid username" do
    @user.username = nil
    assert !@user.valid?
    assert @user.errors[:username].any?

    @user.username = "bigshopper"
    assert @user.valid?, @user.errors.full_messages
  end
  
  test "should require valid email" do
    @user.email = nil
    assert !@user.valid?
    assert @user.errors[:email].any?

    @user.email = "abc@de"
    assert @user.valid?, @user.errors.full_messages
    
    @user.email = "abc"
    assert !@user.valid?
    assert @user.errors[:email].any?
  end
  
  test "should require unique email" do
    @user.email = users(:default).email

    assert !@user.valid?
    assert @user.errors[:email].any?
  end

  test "should require password" do    
    @user.password = nil

    assert !@user.valid?
    assert @user.errors[:password].any?
    assert !@user.errors[:password_confirmation].any?
  end
  
  test "should require password confirmation" do
    @user.password = 'testing'
    @user.password_confirmation = nil

    assert !@user.valid?
    assert !@user.errors[:password].any?
    assert @user.errors[:password_confirmation].any?
  end

  test "require reasonable password length" do
    @user.password = "123456"
    @user.password_confirmation = "123456"

    assert @user.valid?, @user.errors.full_messages

    @user.password = "1234"    
    @user.password_confirmation = "1234"
    
    assert !@user.valid?
    assert @user.errors[:password].any?
    assert_equal "is too short (minimum is 6 characters)", @user.errors[:password].first
  end

  test "should authenticate with a valid login and password" do
    assert_equal users(:default), User.authenticate(users(:default).username, 'testing')
    assert_equal users(:default), User.authenticate(users(:default).email, 'testing')
  end
  
  test "should not authenticate with an invalid login or password" do
    assert_nil User.authenticate('bad_email', 'testing')
    assert_nil User.authenticate(users(:default).username, 'bad_password')
    assert_nil User.authenticate(users(:default).email, 'bad_password')
  end
  
  test "serialize should not contain sensitive information" do
    xml  = Hash.from_xml(@user.to_xml)["user"]
    json = ActiveSupport::JSON.decode(@user.to_json)
    [xml, json].each do |result|
      assert_nil result["password_hash"]
      assert_nil result["password_salt"]
      assert_nil result["email"]
    end
  end

end
