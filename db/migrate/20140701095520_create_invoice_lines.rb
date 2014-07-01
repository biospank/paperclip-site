class CreateInvoiceLines < ActiveRecord::Migration
  def change
    create_table :invoice_lines do |t|
      t.integer  :invoice_id, null: false
      t.string   :description, null: false
      t.decimal  :amount, null: false
      t.integer  :vat_id, null: false
    end

    execute "CREATE INDEX INVOICE_FK_IDX ON invoice_lines (invoice_id)"
    execute "CREATE INDEX VAT_FK_IDX ON invoice_lines (vat_id)"
  end
end
