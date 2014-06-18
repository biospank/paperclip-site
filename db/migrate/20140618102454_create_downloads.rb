class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.integer :user_id
      t.string :url
      t.datetime :created_at
    end
  end
end
