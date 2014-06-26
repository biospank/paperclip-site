class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
	#after_filter :store_location

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

	# def store_location
	# 	# store last url - this is needed for post-login redirect to whatever the user last visited.
	# 	if (request.fullpath != "/users/sign_in" &&
	# 			request.fullpath != "/users/sign_up" &&
	# 			request.fullpath != "/users/password" &&
	# 			request.fullpath != "/users/sign_out" &&
	# 			!request.xhr?) # don't store ajax calls
	# 		session[:previous_url] = request.fullpath
	# 	end
	# end

  protected

  def after_sign_in_path_for(resource)
		session[:previous_url] || session["user_return_to"] || root_path
	end

  def after_sign_out_path_for(resource)
    new_user_session_url
  end


  private

  def user_not_authorized
    flash[:error] = "Non hai l'autorizzazione necessaria per accedere alla risorsa."
    redirect_to(request.referrer || root_path)
  end

end
