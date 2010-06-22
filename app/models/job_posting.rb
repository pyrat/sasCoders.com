class JobPosting < ActiveRecord::Base
 # acts_as_mappable :auto_geocode=>{:field=>:zip}
 acts_as_mappable

 # should this be private? 
 def approved?
   # if today >= start_date + posting.days_to_run.day
   # and approved_at is not blank
   true
 end
end
