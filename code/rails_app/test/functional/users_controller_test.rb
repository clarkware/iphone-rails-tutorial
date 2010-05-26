require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  setup do
    @valid_attributes = { 
        :username => "bigsaver",
        :email    => 'bigsaver@saveup.com', 
        :password => 'secret', 
        :password_confirmation => 'secret'
      }
    
    @user = User.new(@valid_attributes)
  end
  
  test "new should show form" do    
    get :new
    
    assert_not_nil assigns(:user)
    assert_response :success
    assert_template "users/new"
  end
  
  test "create with valid user should create user and redirect" do    
    assert_difference('User.count', 1) do
      create_user
    end
    
    assert_not_nil assigns(:user)
    assert_response :redirect
    assert_redirected_to root_url
  end
  
  test "create with invalid user should show form" do    
    assert_difference('User.count', 0) do
      create_user :username => nil
    end
    
    assert_not_nil assigns(:user)
    assert_response :success
    assert_template "users/new"
  end

protected

  def create_user(options = {})
    post :create, :user => @valid_attributes.merge(options)
  end
  
end
