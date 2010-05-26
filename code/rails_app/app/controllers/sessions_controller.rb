class SessionsController < ApplicationController

  ssl_required :new, :create
      
  def new
  end
  
  def create
    @login = params[:session][:login]
    @password = params[:session][:password]
    
    user = User.authenticate(@login, @password)
  
    respond_to do |format|
      if user
        format.html do 
          reset_session
          session[:user_id] = user.id
          redirect_back_or_default root_url 
        end
        format.any(:xml, :json) { head :ok }
      else
        format.html do 
          flash.now[:error] = "Invalid login or password."
          render :action => :new 
        end
        format.any(:xml, :json) { request_http_basic_authentication }
      end
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to login_url
  end
  
end
