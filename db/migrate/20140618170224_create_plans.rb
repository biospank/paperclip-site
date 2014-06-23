class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :months
      t.decimal :price
      t.decimal :discount
      t.timestamps
    end
  end
end
