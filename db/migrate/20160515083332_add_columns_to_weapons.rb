class AddColumnsToWeapons < ActiveRecord::Migration
  def change
    add_column :weapons, :charge_rate,  :integer
    add_column :weapons, :velocity,     :integer
    add_column :weapons, :blast_radius, :integer
  end
end
