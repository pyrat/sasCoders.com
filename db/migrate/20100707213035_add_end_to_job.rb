class AddEndToJob < ActiveRecord::Migration
  def self.up
    add_column :job_postings, :end_date, :datetime
	remove_column :job_postings, :days_to_run
  end

  def self.down
     remove_column :job_postings, :end_date
	 add_column :job_postings, :days_to_run, :integer
  end
end
