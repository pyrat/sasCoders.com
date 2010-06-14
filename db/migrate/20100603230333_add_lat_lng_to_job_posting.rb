class AddLatLngToJobPosting < ActiveRecord::Migration
  def self.up
    add_column :job_postings, :lat, :float
    add_column :job_postings, :lng, :float
    
  end

  def self.down
    remove_column :job_postings, :lat
    remove_column :job_postings, :lng
  end
end
