class JobPosting < ActiveRecord::Base
 # acts_as_mappable :auto_geocode=>{:field=>:zip}
 acts_as_mappable
 belongs_to :user
 
 def find_by_state(state)
   a = JobPosting.find(:all)
   a.delete_if{ |job| job.state != state }
   return a
 end

 def formatted_end_date
   if end_date.blank?
     return 'blank'
   else
     return end_date.strftime("%m/%d/%y")
   end
 end
 
 def formatted_start_run_date
    if start_run_date.blank?
      return 'blank'
    else
      return start_run_date.strftime("%m/%d/%y")
    end
  end

 # should this be private? 
 def approved?
   if !approved_at.blank? 
     true
   end
 end
 
 def active?
   if !end_date.blank? and Time.now <= end_date and start_run_date <= Time.now
     true
   end
 end
 
 def approve!
   if start_run_date.blank?
     self.start_run_date = Time.now
   else 
	 # did we wait to long to approve it?
     self.start_run_date = Time.now if start_run_date < Time.now
   end
   self.approved_at = Time.now
   self.save
 end
 
 def apply_credit!(credit)
   # a couple conditions to check for:
   # if the start run date is less than today then they are applying credit late and we should set 
   # it to today
   if start_run_date.blank? || start_run_date < Time.now
     self.start_run_date = Time.now
   end
   # the end date could be blank if this ad has never been run, or it could be less than today if 
   # the user is applying credit to an ad that is already expired
   if end_date.blank? || end_date < Time.now
     self.end_date = start_run_date
   end
   credit.times { self.end_date += 30.days }
   self.save
  end
  
end

  