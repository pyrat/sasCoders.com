class ChangeInvoiceProduct < ActiveRecord::Migration
  def self.up
    change_column :Invoices, :product, :integer
  end

  def self.down
  end
end
