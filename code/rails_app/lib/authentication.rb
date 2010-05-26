module Authentication
  
  def self.included(controller)
    controller.send :helper_method, :current_user, :logged_in?
  end
  
  def current_user
    @current_user ||= (login_from_session || login_from_basic_auth)
  end
  
  def logged_in?
    current_user
  end
  
# START:login_required
  def login_required
    return if logged_in?
      
    respond_to do |format| 
      format.html do
        save_location
        redirect_to login_url
      end
      format.any(:json, :xml) do
        unless login_from_basic_auth
          request_http_basic_authentication
        end
      end
    end 
  end
# END:login_required

  def save_location
    session[:return_to] = request.fullpath
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
protected

  def login_from_session
    User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def login_from_basic_auth
    user = authenticate_with_http_basic do |login, password|
      User.authenticate(login, password)
    end
    session[:user_id] = user.id if user
    user
  end

end