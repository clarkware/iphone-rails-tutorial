require 'test_helper'

class CreditsControllerTest < ActionController::TestCase
  
  setup do
    @goal = goals(:ipad)
    @credit = credits(:latte)
  end
  
  test "index should redirect to login when not logged in" do    
    get :index, :goal_id => @goal.to_param

    assert_response :redirect
    assert_redirected_to login_url
  end
  
  test "index via API should be unauthorized when not logged in" do    
    get :index, :goal_id => @goal.to_param, :format => :xml
    
    assert_response 401
  end

  test "index should render credits" do
    login_as :default

    get :index, :goal_id => @goal.to_param

    assert_not_nil assigns(:credits)    
    assert_response :success
    assert_template "credits/index"
  end

  test "index via API should serialize credits" do
    login_via_api_as :default
    
    get :index, :goal_id => @goal.to_param, :format => :xml
    
    assert_not_nil assigns(:credits)    
    assert_response :success
    
    xml = Hash.from_xml(@response.body)
    assert_equal 1, xml["credits"].length
  end
  
  test "show should show credit" do
    login_as :default

    get :show, :goal_id => @goal.to_param, :id => @credit.to_param

    assert_equal @credit, assigns(:credit)
    assert_response :success
    assert_template "credits/show"
  end
  
  test "show via API should serialize credit" do
    login_via_api_as :default
    
    get :show, :goal_id => @goal.to_param, :id => @credit.to_param, :format => :xml
    
    assert_not_nil assigns(:credit)
    assert_response :success
  
    xml = Hash.from_xml(@response.body)
    assert_equal @credit.id, xml["credit"]["id"]
    assert_equal @credit.name, xml["credit"]["name"]
    assert_equal @credit.amount, xml["credit"]["amount"]
  end
  
  test "new should show new credit form" do
    login_as :default

    get :new, :goal_id => @goal.to_param

    assert_not_nil assigns(:credit)    
    assert_response :success
    assert_template "credits/new"
  end
  
  test "new via API should serialize new credit" do
    login_via_api_as :default
    
    get :new, :goal_id => @goal.to_param, :format => :xml
    
    assert_not_nil assigns(:credit)
    assert_response :success
    
    xml = Hash.from_xml(@response.body)
    assert_not_nil xml["credit"]
  end
  
  test "edit should show credit form" do
    login_as :default
    
    get :edit, :goal_id => @goal.to_param, :id => @credit.to_param
    
    assert_equal @credit, assigns(:credit)
    assert_response :success
    assert_template "credits/edit"
  end

  test "create should create credit and redirect" do
    login_as :default

    assert_difference('Credit.count', 1) do
      post :create, :goal_id => @goal.to_param, :credit => @credit.attributes
    end

    assert_response :redirect
    assert_redirected_to goal_path(assigns(:goal))
  end
  
  test "create via API should create and serialize credit" do
    login_via_api_as :default
    
    assert_difference('Credit.count', 1) do
      post :create, :goal_id => @goal.to_param, :credit => @credit.attributes, :format => :xml
    end
    
    assert_not_nil assigns(:credit)
    assert_response :success
  
    xml = Hash.from_xml(@response.body)
    assert_equal @credit.name, xml["credit"]["name"]
    assert_equal @credit.amount, xml["credit"]["amount"]
  end

  test "update should change credit and redirect" do
    login_as :default

    put :update, :goal_id => @goal.to_param, :id => @credit.to_param, 
                 :goal => @credit.attributes

    assert_not_nil assigns(:credit)
    assert_response :redirect
    assert_redirected_to goal_path(assigns(:goal))
  end
  
  test "update via API should change credit and be okay" do
    login_via_api_as :default
    
    put :update, :goal_id => @goal.to_param, :id => @credit.to_param, 
                 :goal => @credit.attributes, :format => :xml
    
    assert_not_nil assigns(:credit)
    assert_response :ok
  end

  test "destroy should destroy credit and redirect" do
    login_as :default

    assert_difference('Credit.count', -1) do
      delete :destroy, :goal_id => @goal.to_param, :id => @credit.to_param
    end

    assert_not_nil assigns(:credit)
    assert_response :redirect
    assert_redirected_to goal_path(assigns(:goal))
  end
  
  test "destroy via API should destroy credit and be okay" do
    login_via_api_as :default
    
    assert_difference('Credit.count', -1) do
      delete :destroy, :goal_id => @goal.to_param, :id => @credit.to_param, :format => :xml
    end
    
    assert_not_nil assigns(:credit)
    assert_response :ok
  end
end

