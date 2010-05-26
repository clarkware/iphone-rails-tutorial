ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # dereference(user, :users) => user
  # dereference(:fred, :users) => users(:fred)
  def dereference(argument, collection)
    if Symbol === argument
      send(collection, argument)
    else
      argument
    end
  end
  
  def login_as(user_record)
    logout
    user = dereference(user_record, :users) if user_record
    @request.session[:user_id] = user_record ? user.id : nil
    user
  end
  
  def logout
    @request.session[:user_id] = nil
    @controller.instance_variable_set("@current_user", nil)
  end
  
  def login_via_api_as(user_record, password="testing")
    logout
    user = dereference(user_record, :users) if user_record
    token = Base64.encode64("#{user.username}:#{password}")
    @request.env['HTTP_AUTHORIZATION'] = "Basic: #{token}"
  end
end
