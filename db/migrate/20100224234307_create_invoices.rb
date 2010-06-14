class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
	  t.integer :amount
      t.datetime :billed_date
      t.string :product

      t.timestamps
    end
  end

  def self.down
    drop_table :invoices
  end
end
