class DownloadsController < ApplicationController
	before_action :authenticate_user!
	
  def new
  end
	
	def create
		url = "https://s3.amazonaws.com/papergest/paperclip/Paperclip-3.0-demo#{params[:category]}#{params[:version]}-setup.exe"

		Download.create!(
			user: current_user,
			url: url
		)

		redirect_to url
		
	end
	
end
