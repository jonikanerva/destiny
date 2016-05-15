require 'open-uri'

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
        attack:           value_by_name(item, 'Attack').try(:maximum_value),
        optics:           value_by_name(item, 'Optics').try(:value),
        rate_of_fire:     value_by_name(item, 'Rate of Fire').try(:value),
        charge_rate:      value_by_name(item, 'Charge Rate').try(:value),
        velocity:         value_by_name(item, 'Velocity').try(:value),
        blast_radius:     value_by_name(item, 'Blast Radius').try(:value),
        impact:           value_by_name(item, 'Impact').try(:value),
        range:            value_by_name(item, 'Range').try(:value),
        stability:        value_by_name(item, 'Stability').try(:value),
        magazine:         value_by_name(item, 'Magazine').try(:value),
        reload_speed:     value_by_name(item, 'Reload').try(:value),
        inventory_size:   value_by_name(item, 'Inventory Size').try(:value),
        equip_speed:      value_by_name(item, 'Equip Speed').try(:value),
        aim_assistance:   value_by_name(item, 'Aim assistance').try(:value),
        recoil_direction: value_by_name(item, 'Recoil direction').try(:value),
      }

      weapon.update! params
    end

    # Attack zero means weapon is "removed"
    Weapon.where(attack: 0).delete_all

    # Download images to assets
    download_images
  end

  private

    def value_by_name(item, name)
      value_array = item.values.to_a

      value_array.keep_if { |w| w.stat_hash == stat_hash(name) }.first
    end

    def stat_hash(name)
      @stat_hash ||= Stat.pluck(:stat_hash, :name)
      array = @stat_hash.dup

      array.keep_if { |w| w.second == name }.flatten.first
    end

    def download_images
      asset_dir = Rails.root.join 'app', 'assets', 'images', 'weapons'

      Weapon.find_each do |weapon|
        url  = "https://www.bungie.net#{weapon.icon}"
        file = "#{asset_dir}/#{File.basename(weapon.icon)}"

        next if File.exist?(file)

        # write file
        open(file, 'wb') { |f| f << open(url).read }
      end
    end
end
