class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
end
