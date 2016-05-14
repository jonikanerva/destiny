class WeaponsController < ApplicationController
  def index
    @weapons = Item.weapons.includes(:values).order(:item_type_name)
  end
end
