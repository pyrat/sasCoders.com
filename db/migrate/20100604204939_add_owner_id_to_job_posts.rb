class AddOwnerIdToJobPosts < ActiveRecord::Migration
  def self.up
    add_column :job_postings, :owner_id, :integer
  end

  def self.down
    remove_column :job_postings, :owner_id
  end
end
