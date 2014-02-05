class PagesController < ApplicationController
	# include HighVoltage::StaticPage
	
	layout :layout_for_page

  def home

  end
  
  private

  def layout_for_page
    case params[:id]
    when 'home'
      'home'
    else
      'application'
    end
  end
end
