class ChangeInvoiceProduct < ActiveRecord::Migration
  def self.up
    change_column :invoices, :product, :integer
  end

  def self.down
  end
end
