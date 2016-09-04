class Item < ActiveRecord::Base
  has_many :values
  has_many :stats, through: :values

  PRIMARY = [
    "Auto Rifle",
    "Hand Cannon",
    "Pulse Rifle",
    "Scout Rifle",
  ]

  SECONDARY = [
    "Fusion Rifle",
    "Shotgun",
    "Sidearm",
    "Sniper Rifle",
  ]

  HEAVY = [
    "Machine Gun",
    "Rocket Launcher",
  ]

  scope :active,    -> { where.not(name: ['', 'Reforge Weapon']) }
  scope :primary,   -> { active.where(item_type_name: PRIMARY) }
  scope :secondary, -> { active.where(item_type_name: SECONDARY) }
  scope :heavy,     -> { active.where(item_type_name: HEAVY) }
  scope :weapons,   -> { active.where(item_type_name: PRIMARY + SECONDARY + HEAVY) }

  def attack
    value_by_name 'Attack'
  end

  def optics
    value_by_name 'Optics'
  end

  def rate_of_fire
    value_by_name 'Rate of Fire'
  end

  def impact
    value_by_name 'Impact'
  end

  def range
    value_by_name 'Range'
  end

  def stability
    value_by_name 'Stability'
  end

  def magazine
    value_by_name 'Magazine'
  end

  def reload
    value_by_name 'Reload'
  end

  def inventory_size
    value_by_name 'Inventory Size'
  end

  def equip_speed
    value_by_name 'Equip Speed'
  end

  def aim_assistance
    value_by_name 'Aim assistance'
  end

  def recoil_direction
    value_by_name 'Recoil direction'
  end

  private

    def value_by_name(name)
      values.to_a.keep_if { |w| w.stat_name == name }.first.try(:value)
    end
end
