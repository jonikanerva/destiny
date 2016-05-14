class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :item_hash, limit: 8, index: true
      t.string  :name
      t.text    :description
      t.string  :icon
      t.integer :tier_type
      t.string  :tier_type_name
      t.string  :item_type_name

      t.timestamps null: false
    end
  end
end
