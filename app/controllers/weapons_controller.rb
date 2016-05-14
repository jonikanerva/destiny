class WeaponsController < ApplicationController
  def index
    @weapons = Item.weapons.includes(:values).order(sort_order)
  end

  private

  def sort_order
    case params[:sort]
    when 'name'
      :name
    when 'tier'
      :tier_type_name
    when 'type'
      :item_type_name
    else
      :item_type_name
    end
  end
end
