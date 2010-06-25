class UpdateJobPostings < ActiveRecord::Migration
  def self.up
    change_column :job_postings, :experience, :text
	remove_column :job_postings, :company_type
	add_column :users, :company_type, :string
  end

  def self.down
    change_column :job_postings, :experience, :string
	add_column :job_postings, company_type, :string
	remove_column :users, :company_type
  end
end
