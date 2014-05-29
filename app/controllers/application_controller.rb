class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  protected

  # def after_sign_in_path_for(resource)
  #   resource
  # end

  def after_sign_out_path_for(resource)
    new_user_session_url
  end
end
