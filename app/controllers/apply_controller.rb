class ApplyController < ApplicationController
  def index
    # not used yet
    @email = params[:email]
     cover_letter = params[:cover_letter]
     file = params[:file]
     @job = JobPosting.find(params[:id])
     @user = @job.user
     
     # save the email and the file in the db
     # create a new email and include the cover letter, cc, job.reference_id, etc
  end

  def collect
    # not used yet
    # do we need anything here?  this will be called from the /show page
    @jobID = params[:id]
    @jobSeeker = JobSeeker.new  # for our form
    
  end
  
  def email
    # just use the person's email address and send the job to them
    @email = params[:email]
    @job = JobPosting.find(params[:id])
    
    ApplicationMailer.deliver_job_details(@email,@job)
    
  end
      
  def success
  end

  def error
  end

end
