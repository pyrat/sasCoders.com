class CreateJobPostings < ActiveRecord::Migration
  def self.up
    create_table :job_postings do |t|
      t.string :reference_id
      t.string :title
      t.string :company_name
      t.string :company_type
      t.text :short_description
      t.text :long_description
      t.string :zip
      t.string :type
      t.string :experience
      t.string :pay
      t.text :addl_instructions
      t.datetime :created_at
      t.datetime :approved_at

      t.timestamps
    end
  end

  def self.down
    drop_table :job_postings
  end
end
