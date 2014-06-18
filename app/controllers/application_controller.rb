class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
	before_filter :store_location

	def store_location
		# store last url - this is needed for post-login redirect to whatever the user last visited.
		if (request.fullpath != "/users/sign_in" &&
				request.fullpath != "/users/sign_up" &&
				request.fullpath != "/users/password" &&
				request.fullpath != "/users/sign_out" &&
				!request.xhr?) # don't store ajax calls
			session[:previous_url] = request.fullpath 
		end
	end
	
  protected

  def after_sign_in_path_for(resource)
		session[:previous_url] || session["user_return_to"] || root_path
	end

  def after_sign_out_path_for(resource)
    new_user_session_url
  end
end
