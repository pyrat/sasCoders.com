include Geokit::Geocoders

class JobPostingController < ApplicationController
  before_filter :logged_in?
  def index
    # just get all the job_postings where approved_at is not blank
	@postings = Array.new
	@postings = JobPosting.find(:all, :conditions=>)
	
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
	@job.owner_id = session[:user_id]
	@job.start_run_date = Date.parse(@job.start_run_date.to_s) unless @job.start_run_date.nil?
	
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
	@job.reference_id = "#{@job.id}sasCoders#{@job.owner_id}"
	@job.save
  end
  
  def edit
  end
  
  def delete
  end
  
  
  

end
