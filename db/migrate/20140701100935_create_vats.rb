class CreateVats < ActiveRecord::Migration
  def change
    create_table :vats do |t|
      t.string   :description, null: false
      t.decimal  :percentage, null: false
      t.integer  :predefined, limit: 1, default: 0
      t.integer  :active, limit: 1, default: 1
    end

  end
end
