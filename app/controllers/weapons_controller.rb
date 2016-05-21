class WeaponsController < ApplicationController
  def index
    @weapons = weapon_types
  end

  private

    def weapon_types
      case params[:type]
      when 'auto_rifles'
        Weapon.auto_rifles
      when 'hand_cannons'
        Weapon.hand_cannons
      when 'pulse_rifles'
        Weapon.pulse_rifles
      when 'scout_rifles'
        Weapon.scout_rifles
      when 'fusion_rifles'
        Weapon.fusion_rifles
      when 'shotguns'
        Weapon.shotguns
      when 'sidearms'
        Weapon.sidearms
      when 'sniper_rifles'
        Weapon.sniper_rifles
      when 'machine_guns'
        Weapon.machine_guns
      when 'rocket_launchers'
        Weapon.rocket_launchers
      else
        redirect_to weapons_path(:auto_rifles)
      end
    end
end
