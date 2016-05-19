class Weapon < ActiveRecord::Base
  scope :auto_rifles,      -> { where(category: 'Auto Rifle') }
  scope :hand_cannons,     -> { where(category: 'Hand Cannon') }
  scope :pulse_rifles,     -> { where(category: 'Pulse Rifle') }
  scope :scout_rifles,     -> { where(category: 'Scout Rifle') }
  scope :fusion_rifles,    -> { where(category: 'Fusion Rifle') }
  scope :shotguns,         -> { where(category: 'Shotgun') }
  scope :sidearms,         -> { where(category: 'Sidearm') }
  scope :sniper_rifles,    -> { where(category: 'Sniper Rifle') }
  scope :machine_guns,     -> { where(category: 'Machine Gun') }
  scope :rocket_launchers, -> { where(category: 'Rocket Launcher') }

  scope :current, -> { where("attack > 200") }
end
