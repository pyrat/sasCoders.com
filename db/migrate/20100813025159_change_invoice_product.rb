class ChangeInvoiceProduct < ActiveRecord::Migration
  def self.up
    drop_column :invoices, :product
	add_column :invoices, :product, :integer
  end

  def self.down
  end
end
