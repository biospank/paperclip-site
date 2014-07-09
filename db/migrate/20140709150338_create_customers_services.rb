class CreateCustomersServices < ActiveRecord::Migration
  def change
    create_table :customers_services do |t|
      t.integer :customer_id, null: false
      t.integer :service_id, null: false
    end

    execute("CREATE INDEX CS_CUSTOMER_FK_IDX ON customers_services (customer_id)")
    execute("CREATE INDEX CS_SERVVICE_FK_IDX ON customers_services (service_id)")

  end
end
