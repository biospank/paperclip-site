class DownloadsController < ApplicationController
	before_action :authenticate_user!

  def new
  end

	def create
		url = "#{ENV['PAPERCLIP_AWS_DOWNLOAD_PATH']}#{params[:category]}#{params[:version]}-setup.exe"

		Download.create!(
			user: current_user,
			url: url
		)

		redirect_to url

	end

end
