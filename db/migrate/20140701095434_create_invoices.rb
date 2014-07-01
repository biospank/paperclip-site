class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :customer_id, null: false
      t.integer :subscription_id, null: false
      t.integer :number, null: false
      t.date :date, null: false
      t.timestamps
    end

    execute "CREATE INDEX CUSTOMER_FK_IDX ON invoices (customer_id)"
    execute "CREATE INDEX SUBSCRIPTION_FK_IDX ON invoices (subscription_id)"
  end
end
