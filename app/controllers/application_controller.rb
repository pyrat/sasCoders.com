# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :fetch_logged_user

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  def logged_in?
    # the session variable should contain a user obj
	# check that the user last logged in within a certain time
	# i think that should be good enough?
	if @user.nil? ||
	   (@user.updated_at.to_i < 1.hour.ago.to_i)
	  # then it was over an hour ago since they last signed in
	  flash[:notice] = "Please login to continue"
      redirect_to :controller => "site", :action => "index"
      return false
	else
	  return true
	end
  end
  
  def fetch_logged_user
    unless session[:user_id].blank?
	  @user = User.find(session[:user_id])
	end
	rescue ActiveRecord::RecordNotFound
  end
end
