include Geokit::Geocoders

class JobPostingController < ApplicationController
  before_filter :logged_in? # logged in returns a valid @user or false
  def index
    # just get all the job_postings where approved_at is not blank
	@postings = Array.new
	@postings = JobPosting.find(:all)
	
	# loop through them and see if they're approved
	
	
	
  end
  
  def addJob
    @jobPosting = JobPosting.new # for our form
	
  end
  
  def manage
    # just get all the jobs where the owners id matches the session[id]
  end
  
  def create
    @job = JobPosting.new(params[:jobPosting])
	@job.user_id = @user.id # does this need to happen?, yes i think so
	
	@job.start_run_date = Date.parse(@job.start_run_date.to_s) unless @job.start_run_date.nil?
	# otherwise the start_run_date gets set in the approved code
	
	#logger.debug
	if @job.zip.blank?
	  # we will have to change this for out-of-US jobs
	  @job.lat = -18.271835
	  @job.lng = 177.90255
	else
	  geo = MultiGeocoder.geocode(@job.zip)
	  @job.lat = geo.lat
	  @job.lng = geo.lng
	end
	@job.save # there is no job.id until it is saved
	@job.reference_id = "#{@job.id}sasCoders#{@job.user_id}"
	@job.save
	@user.jobPostings << @job  # i dont think user needs to be saved again?
  end
  
  def edit
    @job = JobPosting.find(params[:id])
  end
  
  def update
    # updates the job that came from the edit template
	job = JobPosting.new(params[:jobPosting]) # this gets the job with the updated parameters
	job.start_run_date = Date.parse(job.start_run_date.to_s) unless job.start_run_date.nil?
	job.user_id = @user.id # does this need to happen?, yes i think so
	# otherwise the start_run_date gets set in the approved code
	
	#logger.debug
	if job.zip.blank?
	  # we will have to change this for out-of-US jobs
	  job.lat = -18.271835
	  job.lng = 177.90255
	else
	  geo = MultiGeocoder.geocode(job.zip)
	  job.lat = geo.lat
	  job.lng = geo.lng
	end
	currentJob = JobPosting.find(params[:id])
	currentJob.update_attributes(job.attributes)
	render 'user/manage_ads'
	
  end
  
  def preview
    # just a stub for the template?
	# in that case how do we get the parameters?
  end
  
  def apply_credit
    @job = JobPosting.find(params[:id])
  end
  
  def apply_credit_final
    @job = JobPosting.find(params[:id])
	quantity = params[:quantity].to_i
	redirect_to :back and return if quantity < 1
	# make sure the user has enough credits
	if @user.credits < quantity
	  flash[:notice] = "You do not have enough credits"
	  redirect_to :back
	  return
	end
	if @job.approved_at.blank?
	  flash[:notice] = "You can't apply credit to a job that hasn't been approved."
	  redirect_to :back
	  return
	end
	# should we check to make sure the job actually belongs to the user?
	# maybe in future
	
	# apply the credit
	q = quantity *= 30 # each credit is 30 days
	# if the job is expired then reset it
	if @job.end_date.blank? || Time.today > @job.end_date
	  @job.end_date = Time.now
	end
	
	@job.end_date += q.days
	flash[:notice] = "Successfully applied the credit"
	@user.credits -= quantity
	redirect_to :back and return
	
	
  end
  
  def delete
  end
  
  
  

end
