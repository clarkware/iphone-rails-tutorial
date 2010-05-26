require 'test_helper'

class GoalsControllerTest < ActionController::TestCase

  setup do
    @goal = goals(:ipad)
  end

  test "index should redirect to login when not logged in" do    
    get :index
    
    assert_response :redirect
    assert_redirected_to login_url
  end
    
  test "index via API should be unauthorized when not logged in" do    
    get :index, :format => :xml
    
    assert_response 401
  end

  test "index should render goals" do
    login_as :default
    
    get :index

    assert_not_nil assigns(:goals)    
    assert_response :success
    assert_template "goals/index"
  end
  
  test "index via API should serialize goals" do
    login_via_api_as :default
    
    get :index, :format => :xml
    
    assert_not_nil assigns(:goals)    
    assert_response :success
    
    xml = Hash.from_xml(@response.body)
    assert_equal 1, xml["goals"].length
  end
  
  test "show should show goal" do
    login_as :default
    
    get :show, :id => @goal.to_param
    
    assert_equal @goal, assigns(:goal)
    assert_response :success
    assert_template "goals/show"
  end
  
  test "show via API should serialize goal" do
    login_via_api_as :default
    
    get :show, :id => @goal.to_param, :format => :xml
    
    assert_not_nil assigns(:goal)
    assert_response :success
  
    xml = Hash.from_xml(@response.body)
    assert_equal @goal.id, xml["goal"]["id"]
    assert_equal @goal.name, xml["goal"]["name"]
    assert_equal @goal.amount, xml["goal"]["amount"]
  end
  
  test "new should show new goal form" do
    login_as :default
    
    get :new
    
    assert_not_nil assigns(:goal)    
    assert_response :success
    assert_template "goals/new"
  end
  
  test "new via API should serialize new goal" do
    login_via_api_as :default
    
    get :new, :format => :xml
    
    assert_not_nil assigns(:goal)
    assert_response :success
    
    xml = Hash.from_xml(@response.body)
    assert_not_nil xml["goal"]
  end
  
  test "edit should show goal form" do
    login_as :default
    
    get :edit, :id => @goal.to_param
    
    assert_equal @goal, assigns(:goal)
    assert_response :success
    assert_template "goals/edit"
  end
  
  test "create should create goal and redirect" do
    login_as :default
    
    assert_difference('Goal.count', 1) do
      post :create, :goal => @goal.attributes
    end

    assert_response :redirect
    assert_redirected_to goal_url(assigns(:goal))
  end
  
  test "create via API should create and serialize goal" do
    login_via_api_as :default
    
    assert_difference('Goal.count', 1) do
      post :create, :goal => @goal.attributes, :format => :xml
    end
    
    assert_not_nil assigns(:goal)
    assert_response :success
  
    xml = Hash.from_xml(@response.body)
    assert_equal @goal.name, xml["goal"]["name"]
    assert_equal @goal.amount, xml["goal"]["amount"]
  end
  
  test "update should change goal and redirect" do
    login_as :default
    
    put :update, :id => @goal.to_param, :goal => @goal.attributes
    
    assert_not_nil assigns(:goal)
    assert_response :redirect
    assert_redirected_to goal_url(assigns(:goal))
  end
  
  test "update via API should change goal and be okay" do
    login_via_api_as :default
    
    put :update, :id => @goal.to_param, :goal => @goal.attributes, :format => :xml
    
    assert_not_nil assigns(:goal)
    assert_response :ok
  end
  
  test "destroy should destroy goal and redirect" do
    login_as :default
    
    assert_difference('Goal.count', -1) do
      delete :destroy, :id => @goal.to_param
    end
    
    assert_not_nil assigns(:goal)
    assert_response :redirect
    assert_redirected_to goals_url
  end
  
  test "destroy via API should destroy goal and be okay" do
    login_via_api_as :default
    
    assert_difference('Goal.count', -1) do
      delete :destroy, :id => @goal.to_param, :format => :xml
    end
    
    assert_not_nil assigns(:goal)
    assert_response :ok
  end
  
end
