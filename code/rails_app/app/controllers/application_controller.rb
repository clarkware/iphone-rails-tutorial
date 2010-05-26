class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  include Authentication
  include SslRequirement
  
protected

  # Overridden from SslRequirement to allow local requests
  def ssl_required?
    return false unless Rails.env == 'production'
    super
  end

end
