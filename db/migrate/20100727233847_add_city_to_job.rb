class AddCityToJob < ActiveRecord::Migration
  def self.up
     add_column :job_postings, :city, :string
  end

  def self.down
    remove_column :job_postings, :city
  end
end
