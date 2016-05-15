class AddIndexToWeapons < ActiveRecord::Migration
  def change
    add_index :weapons, :category
  end
end
