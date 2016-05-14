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
    "Sword",
  ]

  scope :primary,   -> { where(item_type_name: PRIMARY ) }
  scope :secondary, -> { where(item_type_name: SECONDARY ) }
  scope :heavy,     -> { where(item_type_name: HEAVY ) }
  scope :weapons,   -> { where(item_type_name: PRIMARY + SECONDARY + HEAVY ) }
end
