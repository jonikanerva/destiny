class WeaponsController < ApplicationController
  def index
    @weapons = weapon_types
  end

  private

    def weapon_types
      case params[:type]
      when 'auto_rifle'
        Weapon.auto_rifles
      when 'hand_cannon'
        Weapon.hand_cannons
      when 'pulse_rifle'
        Weapon.pulse_rifles
      when 'scout_rifle'
        Weapon.scout_rifles
      when 'fusion_rifle'
        Weapon.fusion_rifles
      when 'shotgun'
        Weapon.shotguns
      when 'sidearm'
        Weapon.sidearms
      when 'sniper_rifle'
        Weapon.sniper_rifles
      when 'machine_gun'
        Weapon.machine_guns
      when 'rocket_launcher'
        Weapon.rocket_launchers
      else
        Weapon.auto_rifles
      end
    end
end
