class AddSubscriptionTxn < ActiveRecord::Migration
  def change
    add_column :subscriptions, :paypal_txn_id, :string, unique: true
  end
end
