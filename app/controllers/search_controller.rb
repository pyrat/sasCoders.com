include Geokit::Geocoders

class SearchController < ApplicationController
   def index
     @jobs = Array.new  # array that is returned to the view
	 
	 zip = params[:zip]
	 telecommute = params[:telecommute] # select list include|exclude|only
	 city = params[:city]
	 state = params[:state]

	 within = params[:within]
	 
	 within = "10" if within.to_i < 1
	 
	 if telecommute == "only"
	   # make the front end so it never gets here but links to search/telecommute
	   # keep this code here just in case though...
	   redirect_to "/search/telecommute/"
	 end
	 
	 location = "#{city} #{state} #{zip}"
	 
	 @geo = MultiGeocoder.geocode(location)
	 
	 
	 ######################
	 if @geo.success?
	   @img = "http://maps.google.com/maps/api/staticmap?zoom=10&size=200x200&markers=color:blue|#{@geo.lat},#{@geo.lng}&sensor=false"
  	   @jobs = JobPosting.find(:all, :origin=>@geo, :within=>within, :order=>'distance')
	   # add in the loop for valid jobs
	   # um, yuck. even better would be to stick this in the find
	   @jobs.delete_if {|job| job.end_date < Time.now }
	   @jobs.delete_if {|job| (!job.approved? or job.end_date.blank?)}
	   if @jobs.length == 0
	     flash[:error] = "There were no jobs found within #{within} miles of #{location}."
		 return
	   end  
	   # do we need to add some telecommute jobs in?
	   if telecommute == "include"
	     t = Array.new
	     t = JobPosting.find_all_by_telecommute(true)
		 # Merge the two arrays in case a job show up in both, apparently rails knows to use the id?
		 
		 @jobs = t | @jobs if t.length > 0
	   end
	   
	   # successfully return w jobs
	 else 
	   flash[:error] = "That location could not be found."
	 end
	 ######################
	 
   end
   
   def telecommute
     # this is for telecommute "only"
	 @jobs = JobPosting.find_all_by_telecommute(true)
	 render :action=>"index" # just renders it, doesn't run action first
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
