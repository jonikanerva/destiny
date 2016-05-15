class AddTierNumberToWeapons < ActiveRecord::Migration
  def change
    add_column :weapons, :tier_number, :integer
  end
end
