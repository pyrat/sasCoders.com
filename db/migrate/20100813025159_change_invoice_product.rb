class ChangeInvoiceProduct < ActiveRecord::Migration
  def self.up
    remove_column :Invoices, :product
    add_column :product, :integer
  end

  def self.down
  end
end
