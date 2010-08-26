class JobSeekers < ActiveRecord::Migration
  def self.up
    create_table :job_seekers do |t|
      t.string :email
      t.binary :cv, :limit => 1.megabyte
    end
  end

  def self.down
    drop_table :job_seekers
  end
end
