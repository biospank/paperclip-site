class HomeController < ApplicationController

  layout 'home'

  def index
    #response.headers['Last-Modified'] = Time.now
    last_modified = Time.now.utc()
  end
  
end
