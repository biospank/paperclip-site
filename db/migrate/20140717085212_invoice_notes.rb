class InvoiceNotes < ActiveRecord::Migration
  def change
    create_table :invoice_notes do |t|
      t.string   :description, null: false
      t.integer  :active, limit: 1, default: 1
    end
  end
end
