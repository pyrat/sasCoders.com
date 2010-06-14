require 'digest/sha1'

class User < ActiveRecord::Base
  has_and_belongs_to_many :roles
  
  # validations
  # when do validations occur? before the model is saved.
  validates_presence_of :email
  validates_uniqueness_of :email, :case_sensitive => false
  validates_uniqueness_of :user_name, :case_sensitive => false
  
  validates_format_of :email,
                      :with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i,
                      :message => "Improperly formatted email address"

  validates_confirmation_of :password
  validate :password_conforms?  
  
  # Attribute accessors
#  attr_accessor           :password_confirmation  # i dont think this attribute is used anywhere?

  def password_conforms?
    return false if @password.blank? 
	return false if @password != @password_confirmation 
  end
  
  
  def self.authenticate(email, password)
    user = self.find_by_email(email)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end	  	
    end
	user
  end

  #'password' is a virtual attribute i.e. not in the db
  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end
  
  # virtual attribute, just defining a setter, no need for a getter
  def password_confirmation=(p)
    return if p.blank?
    @password_confirmation = p
  end

    
  def has_role?(role)
    list ||= self.roles.map(&:name)
    list.include?(role.to_s) 
  end
  
  def admin?
      self.has_role?('admin')
  end
  
  private
  
  def create_new_salt
    self.salt =self.object_id.to_s + rand.to_s
  end

  def self.encrypted_password(pw, salt)
    string_to_hash = pw + "439fgfg334gergersd9fhq34ufq" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

end
