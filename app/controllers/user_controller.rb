class UserController < ApplicationController
  before_filter :logged_in?, :only=> [:edit, :index]
  
  def index
    @user = User.find(session[:user_id])
    flash[:notice] = nil
  end
  
  def show
  end
  
  def collect
    # i know this is retarded, but i just am not sure how to do it correctly
	# this is a stupid action just so it can render the template
  end
  def register
    # when a user registers, they are not officially logged in/etc until they validate 
	# with their email
	
    @user = User.new
	@user.email = params[:email]
	@user.password = params[:password]
	@user.password_confirmation = params[:password_confirmation]
	@user.first_name = params[:first_name]
	@user.last_name = params[:last_name]	
	@user.telephone = params[:telephone]
	@user.company = params[:company]
	@user.company_type = params[:company_type]
	@user.company_description = [:company_description]
	

	if @user.save
	  
	  # we do not want to log them in yet.
	  #session[:user_id] = @user.id
	  ApplicationMailer.deliver_signup_notification(@user)
	
    else
	  flash[:notice] = "There was an error creating that user."
	  render :collect
	end 
  end
  
  def validate
    # look up the user based on the validation param and then null it out in the db, additionally, 
	# log them in
	# i don't think there is any need for a view, just send to index
	activation = params[:c]
	@user = User.find_by_activation_code(activation)
	if @user
	  # log them in
	  @user.activation_code = nil
	  @user.activated_at = Time.now
	  @user.save
	  session[:user_id] = @user.id
	  flash[:notice] = "Thank you for validating.  You are now logged in."
	  
	  else
	  flash[:notice] = "Something went wrong.  That validation was incorrect."
	end
	render 'site/index'
	
  end

  
  def edit
    @user = User.find(:session[:user_id])
    if @user.save
      flash[:notice] = "Successfully updated"
      render 'index'
    else
      flash[:notice] = "There was a problem."
      flash[:error] = "The updates were not saved."
    end
    
  end
  
  
  def delete
  end
  
  def login
    @user = User.authenticate(params[:email],params[:pw])
	if @user
  	  @user.activated_at = Time.now # does this get saved to the table? or do we have to 
	  # call save to update activated_at in db
	  @user.save
	  session[:user_id] = @user.id
	  flash[:notice] = "Hello #{@user.first_name}"
	  
	  else
	  flash[:notice] = "Login failed."
	end
	render 'site/index' # in future this might be a parameter
  end
  
  
end

  