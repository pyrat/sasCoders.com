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

  def create
    @job = JobPosting.new(params[:jobPosting])
    # we dont want to recreate the job
    # if the u;ser hit the back button, or somehow refreshed the form with the same info
    render "user/index" and return if @job.duplicate?(@user)

    @job.user_id = @user.id # does this need to happen?, yes i think so

    @job.start_run_date = Date.parse(@job.start_run_date.to_s) unless @job.start_run_date.nil?
    # otherwise the start_run_date gets set in the approved code

    #logger.debug
    if @job.zip.blank?
      # we will have to change this for out-of-US jobs
      @job.lat = -18.271835
      @job.lng = 177.90255
      @job.city = 'telecommute'
    else
      geo = MultiGeocoder.geocode(@job.zip)
      @job.lat = geo.lat
      @job.lng = geo.lng
      @job.city = geo.city
      @job.state = geo.state
    end
    @job.approve!  # just approving all new jobs for now
    if @job.save # there is no job.id until it is saved
      @job.reference_id = "#{@job.id}.#{@job.user_id}"
      @job.save
      @user.jobPostings << @job  # i dont think user needs to be saved again?
      flash.now[:notice] = "Job Successfully Created."
    else
      flash.now[:error] = "That job could not be created."
      render :addJob
    end
  end

  def edit
    @job = JobPosting.find(params[:id])
  end

  def update
    # updates the job that came from the edit template
    job = JobPosting.new(params[:jobPosting]) # this gets the job with the updated parameters
    job.start_run_date = Date.parse(job.start_run_date.to_s) unless job.start_run_date.nil?
    # the start run date is too confusing, and probably useless
    #	job.reference_id = "#{job.id}.#{job.user_id}"
    #	job.user_id = @user.id # does this need to happen?, yes i think so
    # otherwise the start_run_date gets set in the approved code

    #logger.debug
    if job.zip.blank?
      # we will have to change this for out-of-US jobs
      job.lat = -18.271835
      job.lng = 177.90255
      job.city = 'telecommute'
    else
      geo = MultiGeocoder.geocode(job.zip)
      job.lat = geo.lat
      job.lng = geo.lng
      job.city = geo.city
    end
    currentJob = JobPosting.find(params[:id])
    #currentJob.update_attributes(job.attributes)
    currentJob.title = job.title
    currentJob.short_description = job.title
    currentJob.experience = job.experience
    currentJob.long_description = job.long_description
    currentJob.telecommute = job.telecommute
    currentJob.zip = job.zip
    currentJob.pay = job.pay
    currentJob.job_type = job.job_type
    currentJob.addl_instructions = job.addl_instructions

    currentJob.save!
    flash.now[:notice] = "The job was edited successfully."
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
    # might be a good idea to stick the job id in a cookie also and check it here
    quantity = params[:quantity].to_i
    redirect_to '/user/manage_ads' and return if quantity < 1
    # make sure the user has enough credits
    if @user.credits < quantity
      flash[:error] = "You do not have enough credits."
      redirect_to '/buy_credits/index' and return
      return
    end
    if @job.approved_at.blank?
      flash[:error] = "You can't apply credit to a job that hasn't been approved."
      redirect_to '/user/manage_ads' and return
      return
    end
    # should we check to make sure the job actually belongs to the user?
    # maybe in future

    # apply the credit
    @job.apply_credit!(quantity)
    flash[:notice] = "Successfully applied the credit."
    @user.credits -= quantity
    @user.save
    redirect_to '/user/manage_ads' and return


  end

  def delete
    # jobs are linked to users, do we need to take care of this?
    j = JobPosting.find(params[:id])
    j.delete
    flash[:notice] = "The ad has been deleted."
    redirect_to '/user/manage_ads' and return
  end




end
