class ModifyJobPostingsTable < ActiveRecord::Migration
  def self.up
    add_column :job_postings, :days_to_run, :integer
	add_column :job_postings, :start_run_date, :datetime

  end

  def self.down
    remove_column :job_postings, :days_to_run
	remove_column :job_postings, :start_run_date
  end
end
