class CreateWeapons < ActiveRecord::Migration
  def change
    create_table :weapons do |t|
      t.integer :item_hash, limit: 8
      t.string :name
      t.text :description
      t.string :category
      t.string :tier
      t.string :icon
      t.integer :attack
      t.integer :optics
      t.integer :rate_of_fire
      t.integer :impact
      t.integer :range
      t.integer :stability
      t.integer :magazine
      t.integer :reload_speed
      t.integer :inventory_size
      t.integer :equip_speed
      t.integer :aim_assistance
      t.integer :recoil_direction

      t.timestamps null: false
    end
  end
end
