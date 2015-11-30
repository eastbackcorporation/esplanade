class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  after_filter  :store_location

protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end

  def store_location
    if (request.fullpath != "/users/sign_in" &&
        request.fullpath != "/users/sign_up" &&
        request.fullpath !~ Regexp.new("\\A/users/password.*\\z") &&
        !request.xhr?)
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    if (session[:previous_url] == root_path)
      super
    else
      session[:previous_url] || root_path
    end
  end
private
  def sign_in_required
    redirect_to new_user_session_url unless user_signed_in?
  end

  def admin_required
    redirect_to new_user_session_url unless user_signed_in? and current_user.admin?
  end
end
