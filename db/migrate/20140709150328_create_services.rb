class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string  :name, null: false
    end
  end
end
