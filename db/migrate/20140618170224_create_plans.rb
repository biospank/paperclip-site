class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.integer  :service_id, null: false
      t.string  :name
      t.integer :months
      t.decimal :price
      t.decimal :discount
      t.timestamps
    end

    execute("CREATE INDEX PLAN_SERVICE_FK_IDX ON plans (service_id)")
  end
end
