class CreateInvoiceSerials < ActiveRecord::Migration
  def change
    create_table :invoice_serials do |t|
      t.integer :serial, :null => false
      t.integer :year, :null => false
    end
  end
end
