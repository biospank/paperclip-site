class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
    t.integer  :user_id, null: false
    t.string   :name, null: false
    t.string   :tax_code, null: false
    t.string   :address, null: false
    t.string   :cap, null: false
    t.string   :city, null: false
    t.boolean  :terms_of_service, null: false, default: false
    t.timestamps
   end

  #  execute "SELECT setval('customers_id_seq', 1000)" rescue nil # postgresql
  #  execute "UPDATE SQLITE_SEQUENCE SET seq = 1000 WHERE name = 'customers'" rescue nil # sqlite
 end
end
