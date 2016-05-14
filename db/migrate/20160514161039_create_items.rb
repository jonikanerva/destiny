class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :item_id, limit: 8, index: true
      t.string :name
      t.string :description
      t.string :icon
      t.string :type_name
      t.integer :tier_type
      t.string :item_type_name

      t.timestamps null: false
    end
  end
end
