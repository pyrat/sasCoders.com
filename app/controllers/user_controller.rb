class UserController < ApplicationController
  before_filter :logged_in?, :only=> [:edit, :index, :save, :save_company, :edit_company, :invoices]
  
  def index
  end
    
  def edit_company
  end
  
  def save_company
    @user.company_description = params[:company_description]
    @user.save
    render 'index'
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
	@user.web_site = params[:web_site]
	@user.company_type = params[:company_type]
	@user.company_description = params[:company_description]
	

	if @user.save
	  
	  # we do not want to log them in yet.
	  #session[:user_id] = @user.id
	  ApplicationMailer.deliver_signup_notification(@user)
	
    else
	  flash[:error] = "There was an error creating that user."
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
	  @user.activation_code = "validated #{Time.now}"

	  @user.activated_at = Time.now
	  @user.save!
	  session[:user_id] = @user.id
	  flash[:notice] = "Thank you for validating.  You are now logged in."
	  render :action => :validated
	  else
	  flash[:error] = "Something went wrong.  That validation was incorrect."
	  render 'site/index'
	end
	
	
  end

  
  def edit
   # we cant use the :user object since it will be fetched again in the save and 
   # overwrite the parameters that were assigned in the template
   # create a model for the form
   @u = @user
    
  end
  
  def save
    # in future need to figure out how to check to make sure the update was applied successfully
=begin	
	if @user.update_attributes(u.attributes)
      flash[:notice] = "Successfully updated"
      render 'index'
    else
      flash[:notice] = "There was a problem."
      flash[:error] = "The updates were not saved."
	  render 'index'
    end
=end
    u = User.new(params[:u])
    @user.update_attributes(u.attributes)
    render 'index'
  end
  
  def delete
  end
  
  def login
    @user = User.authenticate(params[:email],params[:pw])
	if @user
    @user.activated_at = Time.now 
	  @user.save
	  session[:user_id] = @user.id
	  flash[:notice] = "Hello #{@user.first_name}. You are now logged in."
	  
	  else
	  flash[:error] = "Sorry.  The name/password you provided was invalid."
	end
	render 'site/index' # in future this might be a parameter
  end
  
  def logout
    @user = nil
    session[:user_id] = nil
    flash[:notice] = "You have logged out of the site."
    render 'site/index'
  end
  
  def manage_ads
    # maybe get all the active ads in one array
	# and all the inactive ones in another array?
	
  end
  
  def invoices
      # this deletes them from the array, but since the user isn't saved, it doesn't change the db
     @invoices = @user.invoices.delete_if{ |i| i.status == "pending" } 
  end
end

  