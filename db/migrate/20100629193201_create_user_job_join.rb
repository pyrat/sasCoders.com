class CreateUserJobJoin < ActiveRecord::Migration
  def self.up
   add_column :users, :web_site, :string
   rename_column :job_postings, :owner_id, :user_id
  end

  def self.down
	remove_column :users, :web_site
	rename_column :job_postings, :user_id, :owner_id
  end
end
