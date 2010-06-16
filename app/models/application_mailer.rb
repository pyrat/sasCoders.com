class ApplicationMailer < ActionMailer::Base
  
	def signup_notification(user)
	  recipients "#{user.first_name} #{user.last_name} <#{user.email}>"
	  from       "SasCoders.com"
	  subject    "Please Activate Your New Account"
	  sent_on    Time.now
	  body       :name => user.first_name, :link => "http://hollow-meadow-93.heroku.com/user/validate?c=#{user.activation_code}"
	  # the body method takes a hash which generates an instance variable/value per key/value pair
	end  

end
