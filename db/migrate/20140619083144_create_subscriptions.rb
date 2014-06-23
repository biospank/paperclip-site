class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :plan_id, null: false
      t.string :email, null: false
      t.string :key, null: false
      t.string :stripe_customer_token
      t.string :paypal_customer_token
      t.string :paypal_recurring_profile_token

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
