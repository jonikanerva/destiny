class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.string :name
      t.string :description
      t.integer :stat_hash, limit: 8, index: true
      t.timestamps null: false
    end
  end
end
