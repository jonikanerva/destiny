class WeaponsController < ApplicationController
  def index
    @weapons = Weapon.all.order(sort_order)
  end

  private

  def sort_order
    case params[:sort]
    when 'name'
      :name
    when 'description'
      :description
    when 'type'
      :category
    when 'tier'
      :tier
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
      :range
    when 'stability'
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
    else
      :category
    end

  end
end
