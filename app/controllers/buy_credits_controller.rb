class BuyCreditsController < ApplicationController 
  include ActiveMerchant::Billing
  before_filter :logged_in?
  
  def index
  end

  def checkout
    # make sure the n is something real (not 0, 1.2, etc)
    n = params[:n]
	amt = ((n.to_i) *99 ) * 100 # cents!
	invoice = Invoice.new(:status=>"pending", :product=>n, :amount=>amt, :user_id=>@user.id)
	begin
	  invoice.save!
	rescue ActiveRecord::RecordInvalid
	  @message = "The invoice for this transaction could not be created."
	  render :action => 'error'
	end
	# and put the invoice id into a cookie so we can see the number of items selected when they :complete
	session[:i] = invoice.id
	# what can we put in the setup_purchase?  can we put n? and then use it as
	# a param in confirm?
	# no, they are ignored
	# it looks like we will have to store the info in a transaction model
    setup_response = gateway.setup_purchase(invoice.amount,
	  :ip                => request.remote_ip,
	  :return_url        => url_for(:action=> 'confirm', :only_path=>false),
	  :cancel_return_url => url_for(:action=> 'paypal_cancel', :only_path=>false)
	)
	redirect_to gateway.redirect_url_for(setup_response.token)
  end

  def confirm
    redirect_to :action => 'index' unless params[:token]
	
	details_response = gateway.details_for(params[:token])
	# logger.debug(details_response.inspect)
	
	if !details_response.success?
	  @message = details_response.message
	  render :action => 'error'
	  return
	end
	@address = details_response.address
	
	begin
	@invoice = Invoice.find(session[:i])
	rescue ActiveRecord::RecordNotFound
	  @message = "The invoice for this transaction could not be found."
	  render :action => 'error'
	end
  end

  def complete
   	begin
	  @invoice = Invoice.find(session[:i])
	rescue ActiveRecord::RecordNotFound
	  @message = "The invoice for this transaction could not be found."
	  render :action => 'error'
	end
	
    purchase = gateway.purchase(@invoice.amount,
	  :ip => request.remote_ip,
	  :payer_id => params[:payer_id],
	  :token => params[:token]
	)
	
	if !purchase.success?
	  @message  = purchase.message
	  render :action => 'error'
	  return
	end
	
	# otherwise the purchase was a success so
	# update the invoice
	# update the user obj
	# send them an email
	@invoice.status = "paid"
	@invoice.billed_date = Time.now
	@invoice.updated_at = Time.now
	@invoice.save
	@user.credits += @invoice.product
	@user.save
	ApplicationMailer.deliver_signup_notification(@user,@invoice)
	
  end

  def paypal_success
  end

  def paypal_cancel
  end
  
private 
  def gateway
    @gateway ||= PaypalExpressGateway.new(
	  :login     => 'stephen_api1.stephenphilp.com',
	  :password  => 'CXUEKU4HPWQMHDZH',
	  :signature => 'AFrZExOj4oZJL0pjnjNubvZe6wS.AkaUXiolJyCCQulCZGN5GdaacSOy'
	)
  end

end
