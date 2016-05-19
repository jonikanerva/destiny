class AddMinmaxToWeapons < ActiveRecord::Migration
  def change
    add_column :weapons, :optics_min,           :integer
    add_column :weapons, :optics_max,           :integer
    add_column :weapons, :rate_of_fire_min,     :integer
    add_column :weapons, :rate_of_fire_max,     :integer
    add_column :weapons, :charge_rate_min,      :integer
    add_column :weapons, :charge_rate_max,      :integer
    add_column :weapons, :velocity_min,         :integer
    add_column :weapons, :velocity_max,         :integer
    add_column :weapons, :blast_radius_min,     :integer
    add_column :weapons, :blast_radius_max,     :integer
    add_column :weapons, :impact_min,           :integer
    add_column :weapons, :impact_max,           :integer
    add_column :weapons, :range_min,            :integer
    add_column :weapons, :range_max,            :integer
    add_column :weapons, :stability_min,        :integer
    add_column :weapons, :stability_max,        :integer
    add_column :weapons, :magazine_min,         :integer
    add_column :weapons, :magazine_max,         :integer
    add_column :weapons, :reload_speed_min,     :integer
    add_column :weapons, :reload_speed_max,     :integer
    add_column :weapons, :inventory_size_min,   :integer
    add_column :weapons, :inventory_size_max,   :integer
    add_column :weapons, :equip_speed_min,      :integer
    add_column :weapons, :equip_speed_max,      :integer
    add_column :weapons, :aim_assistance_min,   :integer
    add_column :weapons, :aim_assistance_max,   :integer
    add_column :weapons, :recoil_direction_min, :integer
    add_column :weapons, :recoil_direction_max, :integer
  end
end
