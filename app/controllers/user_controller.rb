class UserController < ApplicationController
  before_filter :logged_in?, :only=> :edit
  
  def index
    @users = User.find(:all)
  end
  
  def show
  end
  
  def collect
    # i know this is retarded, but i just am not sure how to do it correctly
	# this is a stupid action just so it can render the template
  end
  def register
    # how do i keep this from running when i just want the other
	# page to call them template?
    @user = User.new
	@user.email = params[:email]
	@user.user_name = params[:user_name]
	@user.password = params[:password]
	@user.password_confirmation = params[:password_confirmation]
	@user.create_activation_code # this might need to be moved to a before save or somehing?
	if @user.save
	  flash[:notice] = "You successfully registered."
	  @user.activated_at = Time.now
	  # i think we need to save it (again) to write it to the db w the activated_at
	  @user.save
	  # we should also let them know they are logged in
	  session[:user_id] = @user.id
	# render does not actually run the method
	  # so...
	  self.index
	  render :action => :index 
    else
	  flash[:notice] = "There was an error creating that user."
	  render :collect
	end 
  end
  
  def edit
  end
  
  def update
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
	end
	render 'site/index' # in future this might be a parameter
  end
end

  def validate
    # look up the user based on the validation param and then null it out in the db, additionally, 
	# log them in
	# i don't think there is any need for a view, just send to index
  end
