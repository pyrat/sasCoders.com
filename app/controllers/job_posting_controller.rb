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
	@job.user_id = @user.id # does this need to happen?
	
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
  
  def delete
  end
  
  
  

end
