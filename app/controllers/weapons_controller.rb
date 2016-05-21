class WeaponsController < ApplicationController
  def index
    @weapons = weapon_types
  end

  private

    def weapon_types
      case params[:type]
      when 'auto_rifles'
        cookies[:weapon_type] = params[:type]
        Weapon.auto_rifles
      when 'hand_cannons'
        cookies[:weapon_type] = params[:type]
        Weapon.hand_cannons
      when 'pulse_rifles'
        cookies[:weapon_type] = params[:type]
        Weapon.pulse_rifles
      when 'scout_rifles'
        cookies[:weapon_type] = params[:type]
        Weapon.scout_rifles
      when 'fusion_rifles'
        cookies[:weapon_type] = params[:type]
        Weapon.fusion_rifles
      when 'shotguns'
        cookies[:weapon_type] = params[:type]
        Weapon.shotguns
      when 'sidearms'
        cookies[:weapon_type] = params[:type]
        Weapon.sidearms
      when 'sniper_rifles'
        cookies[:weapon_type] = params[:type]
        Weapon.sniper_rifles
      when 'machine_guns'
        cookies[:weapon_type] = params[:type]
        Weapon.machine_guns
      when 'rocket_launchers'
        cookies[:weapon_type] = params[:type]
        Weapon.rocket_launchers
      else
        type = cookies[:weapon_type] || :auto_rifles
        redirect_to weapons_path(type)
      end
    end
end
