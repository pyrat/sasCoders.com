class ApplicationMailer < ActionMailer::Base
  
	def signup_notification(user)
	  recipients "#{user.first_name} #{user.last_name} <#{user.email}>"
	  from       "SasCoders.com"
	  subject    "Please Activate Your New Account"
	  sent_on    Time.now
	  body       :name => user.first_name, :link => "http://hollow-meadow-93.heroku.com/user/validate?c=#{user.activation_code}"
	  # the body method takes a hash which generates an instance variable/value per key/value pair
	end  

    def payment_notification(invoice)
	  recipients "#{invoice.user.first_name} #{invoice.user.last_name} <#{invoice.user.email}>"
	  from       "SasCoders.com"
	  subject    "Your Payment Was Received"
	  sent_on    Time.now
	  body       :name => invoice.user.first_name, 
	             :invoice_id => invoice.id, 
				 :n => invoice.product,
				 :amount => invoice.amount,
				 :billed_date => invoice.billed_date
	  # the body method takes a hash which generates an instance variable/value per key/value pair
	end  

  def job_details(email, job)
    recipients "<#{email}>"
    from "sasCoders.com"
    subject "Job Details For Job #{job.title} => #{job.reference_id}"
    sent_on Time.now
    body :job => job   
     
  end
end
