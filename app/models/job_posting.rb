class JobPosting < ActiveRecord::Base
 # acts_as_mappable :auto_geocode=>{:field=>:zip}
 acts_as_mappable
 belongs_to :user

 # should this be private? 
 def approved?
   # if today >= start_date + posting.days_to_run.day
   # and approved_at is not blank
   
   # nope, we now have an end_date so that credits can be applied while a job is running
   if today <= end_date and approved_at is not blank
   true
 end
 
 def approve!
   if start_run_date.blank?
     start_run_date = Time.now
   else 
	 # did we wait to long to approve it?
     start_run_date = Time.now if start_run_date < Time.now
   end
   approved_at = Time.now
   save
 end
 
 def apply_credit!(credit)
   # a couple conditions to check for:
   # if the start run date is less than today then they are applying credit late and we should set 
   # it to today
   if start_run_date.blank? || start_run_date < Time.now
     start_run_date = Time.now
   end
   # the end date could be blank if this ad has never been run, or it could be less than today if 
   # the user is applying credit to an ad that is already expired
   if end_date.blank? || end_date < Time.now
     end_date = start_run_date
   end
   credit.times { end_date += 30.days }
   save
  end
  
end

  