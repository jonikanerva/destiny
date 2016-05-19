class WeaponsController < ApplicationController
  def index
    @weapons = weapon_types.order(sort_order)
  end

  private

    def weapon_types
      weapons = Weapon.all

      if params[:current]
        weapons = Weapon.current
      end

      type = case params[:type]
      when 'auto_rifle'
        weapons.auto_rifles
      when 'hand_cannon'
        weapons.hand_cannons
      when 'pulse_rifle'
        weapons.pulse_rifles
      when 'scout_rifle'
        weapons.scout_rifles
      when 'fusion_rifle'
        weapons.fusion_rifles
      when 'shotgun'
        weapons.shotguns
      when 'sidearm'
        weapons.sidearms
      when 'sniper_rifle'
        weapons.sniper_rifles
      when 'machine_gun'
        weapons.machine_guns
      when 'rocket_launcher'
        weapons.rocket_launchers
      else
        weapons.auto_rifles
      end
    end

    def sort_order
      field = case params[:sort]
      when 'name'
        :name
      when 'description'
        :description
      when 'tier'
        :tier_number
      when 'icon'
        :icon
      when 'attack'
        :attack
      when 'optics'
        :optics
      when 'rof'
        :rate_of_fire
      when 'impact'
        :impact
      when 'range'
        'weapons.range'
      when 'stab'
        :stability
      when 'mag'
        :magazine
      when 'reload'
        :reload_speed
      when 'inventory'
        :inventory_size
      when 'equip'
        :equip_speed
      when 'aa'
        :aim_assistance
      when 'recoil'
        :recoil_direction
      when 'charge'
        :charge_rate
      when 'velo'
        :velocity
      when 'blast'
        :blast_radius
      else
        :tier_number
      end

      "#{field} #{sort_direction}, aim_assistance desc"
    end

    def sort_direction
      params[:order] == 'asc' ? :asc : :desc
    end
end
