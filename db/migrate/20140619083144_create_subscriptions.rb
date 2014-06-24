class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer  :user_id, null: false
      t.integer  :plan_id, null: false
      t.string   :email, null: false
      t.string   :key, unique: true
      t.string   :paypal_payment_token, unique: true
      t.string   :paypal_customer_token, unique: true
      t.decimal  :amount
      t.date     :expiry_date
      t.string   :state
      t.text     :error

      t.timestamps
    end
  end
end

#class Customer < ActiveRecord::Migration
#  def change
#    create_table :customers do |t|
#      t.string :email
#
#      t.timestamps
#    end
#
#    execute "SELECT setval('customers_id_seq', 1000)" rescue nil # postgresql
#    execute "UPDATE SQLITE_SEQUENCE SET seq = 1000 WHERE name = 'customers'" rescue nil # sqlite
#  end
#end
