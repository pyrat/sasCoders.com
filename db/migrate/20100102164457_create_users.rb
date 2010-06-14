class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :user_name
      t.string :display_name
      t.string :hashed_password
      t.string :salt
      t.string :remember_token
      t.string :activation_code
      t.string :state
      t.datetime :remember_token_expires_at
      t.datetime :activated_at
	  t.string :first_name
      t.string :last_name
      t.string :telephone
      t.string :company
	  
      t.timestamps
    end
	
	create_table :roles do |t|
      t.string :name
    end

    create_table :roles_users, :id => false do |t|
      t.belongs_to :role
      t.belongs_to :user
    end
	
	admin_role = Role.create(:name => 'admin')
	admin = User.new (:user_name=>'admin', :email=>'admin@sasCoders.com', :first_name=>'Stephen', :last_name=>'Philp')
	admin.password = 'mos2es'
	admin.roles<<admin_role
    admin.save!
	
  end

  def self.down
    drop_table :users
	drop_table :roles
	drop_table :roles_users
  end
end
