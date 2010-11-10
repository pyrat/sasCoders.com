include Geokit::Geocoders

class SearchController < ApplicationController
   def index
     @jobs = Array.new  # array that is returned to the view
	 
	 zip = params[:zip]
	 @telecommute = params[:telecommute] # select list include|exclude|only
	 city = params[:city]
	 state = params[:state]

	 within = params[:within]
	 
	 within = "10" if within.to_i < 1
	 
	 if zip.blank? and city.blank? and state.blank? 
	   telecommute = "only"
	 end
#	 within = "40" if zip.blank?
	 
	 if telecommute == "only"
	   # make the front end so it never gets here but links to search/telecommute
	   # keep this code here just in case though...
	   redirect_to "/search/get_all/"
	   return
	 end
	 
	 location = "#{city} #{state} #{zip}"
	 
	 @geo = MultiGeocoder.geocode(location)
	 
	 
	 ######################
	 if @geo.success?
	   @img = "http://maps.google.com/maps/api/staticmap?zoom=10&size=200x200&markers=color:blue|#{@geo.lat},#{@geo.lng}&sensor=false"
	   if !(zip.blank? and city.blank?)
  	   @jobs = JobPosting.find(:all, :origin=>@geo, :within=>within, :order=>'distance')
	   elsif zip.blank? and city.blank? and !state.blank?
	     @jobs = JobPosting.search_by_state(state)
	   end
	   # add in the loop for valid jobs
	   # um, yuck. even better would be to stick this in the find
	   @jobs.delete_if {|job| job.end_date.blank? or (job.end_date < Time.now) }
	   @jobs.delete_if {|job| !job.approved?}
	   if @jobs.length == 0
	     flash.now[:error] = "There were no jobs found within #{within} miles of #{location}."
		 return
	   end  
	   # do we need to add some telecommute jobs in?
	   if @telecommute == "include"
	     t = Array.new
	     t = JobPosting.find_all_by_telecommute(true)
		 
		 t.delete_if {|job| job.end_date.blank? or (job.end_date < Time.now) }
 	   t.delete_if {|job| !job.approved?}
 	   # Merge the two arrays in case a job show up in both, apparently rails knows to use the id?
		 @jobs = t | @jobs if t.length > 0
	   end
	   
	   @jobs.sort!{|a,b| b.start_run_date.to_i <=> a.start_run_date.to_i}
	   # successfully return w jobs
	   flash.now[:notice] = "There were #{@jobs.length} jobs found."
	 else 
	   flash.now[:error] = "That location could not be found."
	 end
	 ######################
	 
   end
   
   def telecommute
     # this is for telecommute "only"
	 @jobs = JobPosting.find_all_by_telecommute(true, :order => "start_run_date DESC")
	 @jobs.delete_if {|job| job.end_date.blank? or (job.end_date < Time.now) }
	 @jobs.delete_if {|job| !job.approved?}
	 @action = "telecommute"
	 if @jobs.length > 0
	   flash.now[:notice] = "There were #{@jobs.length} jobs found."
	 else
	   flash.now[:error] = "There were no jobs found."
	 end
	 render :action=>"index" # just renders it, doesn't run action first
   end
   
   def get_all
     @jobs = JobPosting.find(:all, :order => "start_run_date DESC")
     @jobs.delete_if {|job| job.end_date.blank? or (job.end_date < Time.now) }
   	 @jobs.delete_if {|job| !job.approved?}
   	 @action = 'get_all'
   	 if @jobs.length > 0
   	   flash.now[:notice] = "There were #{@jobs.length} jobs found."
   	 else
   	   flash.now[:error] = "There were no jobs found."
   	 end
     
   	 render :action => 'index'
   end
   
   def by_state
     @jobs = Array.new
     state = params[:state]
     @geo = MultiGeocoder.geocode(state)
     @img = "http://maps.google.com/maps/api/staticmap?zoom=5&size=200x200&markers=color:blue|#{@geo.lat},#{@geo.lng}&sensor=false"
     @jobs = JobPosting.search_by_state(state)
     @jobs.delete_if {|job| job.end_date.blank? or (job.end_date < Time.now) }
 	   @jobs.delete_if {|job| !job.approved?}
 	   if @jobs.length == 0
 	     flash.now[:error] = "There were no jobs found within #{state}."
 	     render :action=>"index"
 		   return
	   end
     
     @jobs.sort!{|a,b| b.start_run_date.to_i <=> a.start_run_date.to_i}
     flash.now[:notice] = "There were #{@jobs.length} jobs found in #{state}"
     render :action=>"index"
   end
   
   def show
     @job = JobPosting.find(params[:id])
	 @geo = MultiGeocoder.geocode("#{@job.lat},#{@job.lng}")
	 @city = @geo.city
	 
     # should this be something more like @job.user_id.company ?
	 u = User.find(@job.user_id)
	 @companyName = u.company
	 @companyDescription = u.company_description

   end
end
