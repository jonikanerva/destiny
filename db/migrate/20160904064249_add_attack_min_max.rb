class AddAttackMinMax < ActiveRecord::Migration
  def change
    add_column :weapons, :attack_min, :integer
    add_column :weapons, :attack_max, :integer
  end
end
