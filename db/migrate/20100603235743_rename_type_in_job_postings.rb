class RenameTypeInJobPostings < ActiveRecord::Migration
  def self.up
    rename_column :job_postings, :type, :job_type
	add_column :job_postings, :telecommute, :boolean
  end

  def self.down
    rename_column :job_postings, :job_type, :type
	remove_column :job_postings, :telecommute
  end
end
