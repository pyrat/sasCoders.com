require 'digest/sha1'

class User < ActiveRecord::Base
  has_and_belongs_to_many :roles
  has_many :jobPostings
  has_many :invoices

  attr_protected :email, :salt, :hashed_password, :created_at # protects against mass assignment (update attributes)

  # validations
  # when do validations occur? before the model is saved.
  validates_presence_of :email
  validates_uniqueness_of :email, :case_sensitive => false

  validates_format_of :email,
  :with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i,
  :message => "Improperly formatted email address"

  #  validates_confirmation_of :password
  validate :password_conforms?

  def after_save
    # apparently this gets run whether the model passes validation or not
    # this kind of makes the validation useless
    create_activation_code
  end
  # Attribute accessors
  attr_accessor           :password_confirmation

  def password_conforms?
    return false if @password.blank?
    return false if @password != @password_confirmation
  end


  def self.authenticate(email, password)
    user = self.find_by_email(email)
    if user
      # logger.info("Found the user in authenticate")
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        #  logger.info("The passwords did not match: #{expected_password} != #{user.hashed_password}")
        user = nil
      end
      # additionally check if they have registered
      user = nil if !user.activation_code.include? 'validated'
    end
    user
  end

  #'password' is a virtual attribute i.e. not in the db
  def password # getter
    @password
  end

  def password=(pwd) # setter
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

  # next few virtual attributes, just getters
  def total_amt_purchased
    total = 0
    invoices.each { |i| total += i.amount if i.status == "paid" }
    return total
  end

  def total_product_purchased
    total = 0
    invoices.each {|i| total += i.product if i.status == "paid" }
    return total
  end

  def jobs_awaiting_approval
    a = Array.new
    jobPostings.each do |j|
      a.push(j) if !j.approved?
    end
    a
  end

  def jobs_expired
    a = Array.new
    jobPostings.each do |j|
      a.push(j) if !j.active?
    end
    a
  end

  def jobs_running
    a = Array.new
    jobPostings.each do |j|
      a.push(j) if j.active? and j.approved?
    end
    a
  end


  def has_role?(role)
    list ||= self.roles.map(&:name)
    list.include?(role.to_s)
  end

  def admin?
    self.has_role?('admin')
  end

  private

  def create_activation_code
    # since this is run after_initialize it has the potential to keep recreating activation codes
    # this will be run whether the object passed validation or not so... there will be no activation_code
    # attribute since it didn't get saved to the db

    if self.activation_code.blank?
      self.activation_code = Digest::SHA1.hexdigest(self.object_id.to_s + rand.to_s)
      save! # jeesh
    end
  end

  def create_new_salt
    self.salt =self.object_id.to_s + rand.to_s
  end

  def self.encrypted_password(pw, salt)
    string_to_hash = pw + "439fgfg334gergersd9fhq34ufq" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

end
