class WeaponsController < ApplicationController
  def index
    @weapons = weapon_types
  end

  private

    def weapon_types
      if params[:type] && Item.pluck(:item_type).include?(params[:type])
        cookies[:weapon_type] = params[:type]
        Item.includes(:values, :stats).where(item_type: params[:type])
      else
        type = cookies[:weapon_type] || 'auto-rifles'
        redirect_to weapons_path(type)
      end
    end
end
