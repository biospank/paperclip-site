class PaymentNotification < ActiveRecord::Migration
  def change
    create_table :payment_notifications do |t|
      t.integer :subscription_id
      t.text    :detail

      t.timestamps
    end
  end
end
