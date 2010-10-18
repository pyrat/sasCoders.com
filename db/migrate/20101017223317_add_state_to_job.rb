class AddStateToJob < ActiveRecord::Migration
  def self.up
    add_column :job_postings, :state, :string
  end

  def self.down
    remove_column :job_postings, :state
  end
end
