class RemoveWeaponsTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :weapons
  end
end
