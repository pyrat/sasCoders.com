class SiteController < ApplicationController
  def index
  end
  
  def employers
    response.headers['Cache-Control'] = 'public, max-age=1440'
  end
  
  def coders
    response.headers['Cache-Control'] = 'public, max-age=1440'
  end 
end
