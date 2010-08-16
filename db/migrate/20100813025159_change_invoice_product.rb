class ChangeInvoiceProduct < ActiveRecord::Migration
  def self.up
    remove_column :invoices, :product
	add_column :invoices, :product, :integer
  end

  def self.down
  end
end
