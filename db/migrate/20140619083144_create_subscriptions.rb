class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer  :user_id, null: false
      t.integer  :plan_id, null: false
      t.string   :email, null: false
      t.string   :key, unique: true
      t.string   :info
      t.string   :paypal_payment_token, unique: true
      t.string   :paypal_customer_token, unique: true
      t.decimal  :amount
      t.date     :expiry_date
      t.string   :state

      t.timestamps
    end
  end
end
