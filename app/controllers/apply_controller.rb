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
    
    if (request.xhr?)
      ApplicationMailer.deliver_job_details(@email,@job)
      flash[:notice] = "Email sent to <#{@email}>."
      render :text => "Email sent." 
    else    
     ApplicationMailer.deliver_job_details(@email,@job)
     render :action => :email
    end
        
  end
      
  def success
  end

  def error
  end

end
