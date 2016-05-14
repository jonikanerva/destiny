class CreateAttributes < ActiveRecord::Migration
  def change
    create_table :attributes do |t|
      t.references :item, index: true, foreign_key: true
      t.integer :stat_hash, limit: 8, index: true
      t.integer :value
      t.integer :minimum_value
      t.integer :maximum_value

      t.timestamps null: false
    end
  end
end
