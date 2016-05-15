class UpdateWeaponsJob < ActiveJob::Base
  queue_as :default

  def perform()
    Item.weapons.includes(:values).find_each do |item|
      weapon = Weapon.find_or_initialize_by item_hash: item.item_hash

      params = {
        item_hash:        item.item_hash,
        name:             item.name,
        description:      item.description,
        category:         item.item_type_name,
        tier:             item.tier_type_name,
        tier_number:      item.tier_type,
        icon:             item.icon,
        attack:           value_by_name(item, 'Attack'),
        optics:           value_by_name(item, 'Optics'),
        rate_of_fire:     value_by_name(item, 'Rate of Fire'),
        impact:           value_by_name(item, 'Impact'),
        range:            value_by_name(item, 'Range'),
        stability:        value_by_name(item, 'Stability'),
        magazine:         value_by_name(item, 'Magazine'),
        reload_speed:     value_by_name(item, 'Reload'),
        inventory_size:   value_by_name(item, 'Inventory Size'),
        equip_speed:      value_by_name(item, 'Equip Speed'),
        aim_assistance:   value_by_name(item, 'Aim assistance'),
        recoil_direction: value_by_name(item, 'Recoil direction'),
      }

      weapon.update! params
    end
  end

  private

    def value_by_name(item, name)
      value_array = item.values.to_a

      value_array.keep_if { |w| w.stat_hash == stat_hash(name) }.first.try(:value)
    end

    def stat_hash(name)
      @stat_hash ||= Stat.pluck(:stat_hash, :name)
      array = @stat_hash.dup

      array.keep_if { |w| w.second == name }.flatten.first
    end
end
