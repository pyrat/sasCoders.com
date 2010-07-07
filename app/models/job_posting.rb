class JobPosting < ActiveRecord::Base
 # acts_as_mappable :auto_geocode=>{:field=>:zip}
 acts_as_mappable
 belongs_to :user

 # should this be private? 
 def approved?
   # if today >= start_date + posting.days_to_run.day
   # and approved_at is not blank
   
   # nope, we now have an end_date so that credits can be applied while a job is running
   # if today <= end_date and approved_at is not blank
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
   if end_date.blank?
     end_date = start_run_date
   end
   credit.times { end_date += 15.day }
   save
  end
  
end

  