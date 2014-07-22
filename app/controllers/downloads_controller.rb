class DownloadsController < ApplicationController
	before_action :authenticate_user!

  def new
  end

	def create
		url = File.join("#{ENV['PAPERCLIP_S3_DOWNLOAD_PATH']}", "Paperclip-3.0-demo#{params[:category]}#{params[:version]}-setup.exe"

		Download.create!(
			user: current_user,
			url: url
		)

		redirect_to url

	end

end
