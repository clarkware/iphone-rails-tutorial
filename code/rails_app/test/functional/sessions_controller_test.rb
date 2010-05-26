require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  
  setup do
    @user = users(:default)
  end
  
  test "new should render login page" do
    get :new
    
    assert_response :success
    assert_template "sessions/new"
  end
  
  test "create with valid credentials should log in user and redirect" do
    create_session
    
    assert session[:user_id]
    assert_equal @user.id, session[:user_id]
    assert_response :redirect
    assert_redirected_to root_url
  end
  
  test "create with invalid credentials should show login form" do
    create_session :login => @user.email, :password => 'badpass'
    
    assert_nil session[:user_id]
    assert_response :success
    assert_template "sessions/new"
  end
  
  test "destroy should log user out" do
    login_as :default
    
    delete :destroy
    
    assert_nil session[:user_id]    
    assert_redirected_to login_url
  end
  
  test "should be logged in with valid user id in session" do
    login_as @user
    
    get :new

    assert_equal @user, @controller.send(:current_user) 
    assert @controller.send(:logged_in?)   
  end
  
  test "should not be logged in with invalid user id in session" do
    login_as User.new
      
    get :new

    assert_nil @controller.send(:current_user) 
    assert !@controller.send(:logged_in?)   
  end
  
  test "should be logged in with valid credentials in basic auth" do
    login_via_api_as :default, "testing"

    get :new

    assert_equal @user, @controller.send(:current_user)  
    assert @controller.send(:logged_in?)  
  end
  
  test "should not be logged in with invalid credentials in basic auth" do
    login_via_api_as :default, "bad_password"
    
    get :new

    assert_nil @controller.send(:current_user) 
    assert !@controller.send(:logged_in?)
  end
  
protected

  def create_session(options = {})
    default_options = {:login => @user.email, :password => 'testing'}
    post :create, :session => default_options.merge(options)
  end

end
