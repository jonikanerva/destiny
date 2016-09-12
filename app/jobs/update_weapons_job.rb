require 'open-uri'

class UpdateWeaponsJob < ActiveJob::Base
  queue_as :default

  def perform
    Weapon.delete_all

    update_weapons

    # Attack zero means weapon is "removed"
    # Weapon.where(attack: 0).delete_all
    # Weapon.where('attack_max < 160').delete_all

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

    def update_weapons
      progressbar = progress_bar Item.weapons.count, 'Updating weapons'

      Item.weapons.includes(:values).find_each do |item|
        weapon = Weapon.find_or_initialize_by item_hash: item.item_hash

        params = {
          item_hash:            item.item_hash,
          name:                 item.name.strip,
          description:          item.description.strip,
          category:             item.item_type_name.strip,
          tier:                 item.tier_type_name.strip,
          tier_number:          item.tier_type,
          icon:                 item.icon,
          attack:               value_by_name(item, 'Attack').try(:value),
          attack_min:           value_by_name(item, 'Attack').try(:minimum_value),
          attack_max:           value_by_name(item, 'Attack').try(:maximum_value),
          optics:               value_by_name(item, 'Optics').try(:value),
          optics_min:           value_by_name(item, 'Optics').try(:minimum_value),
          optics_max:           value_by_name(item, 'Optics').try(:maximum_value),
          rate_of_fire:         value_by_name(item, 'Rate of Fire').try(:value),
          rate_of_fire_min:     value_by_name(item, 'Rate of Fire').try(:minimum_value),
          rate_of_fire_max:     value_by_name(item, 'Rate of Fire').try(:maximum_value),
          charge_rate:          value_by_name(item, 'Charge Rate').try(:value),
          charge_rate_min:      value_by_name(item, 'Charge Rate').try(:minimum_value),
          charge_rate_max:      value_by_name(item, 'Charge Rate').try(:maximum_value),
          velocity:             value_by_name(item, 'Velocity').try(:value),
          velocity_min:         value_by_name(item, 'Velocity').try(:minimum_value),
          velocity_max:         value_by_name(item, 'Velocity').try(:maximum_value),
          blast_radius:         value_by_name(item, 'Blast Radius').try(:value),
          blast_radius_min:     value_by_name(item, 'Blast Radius').try(:minimum_value),
          blast_radius_max:     value_by_name(item, 'Blast Radius').try(:maximum_value),
          impact:               value_by_name(item, 'Impact').try(:value),
          impact_min:           value_by_name(item, 'Impact').try(:minimum_value),
          impact_max:           value_by_name(item, 'Impact').try(:maximum_value),
          range:                value_by_name(item, 'Range').try(:value),
          range_min:            value_by_name(item, 'Range').try(:minimum_value),
          range_max:            value_by_name(item, 'Range').try(:maximum_value),
          stability:            value_by_name(item, 'Stability').try(:value),
          stability_min:        value_by_name(item, 'Stability').try(:minimum_value),
          stability_max:        value_by_name(item, 'Stability').try(:maximum_value),
          magazine:             value_by_name(item, 'Magazine').try(:value),
          magazine_min:         value_by_name(item, 'Magazine').try(:minimum_value),
          magazine_max:         value_by_name(item, 'Magazine').try(:maximum_value),
          reload_speed:         value_by_name(item, 'Reload').try(:value),
          reload_speed_min:     value_by_name(item, 'Reload').try(:minimum_value),
          reload_speed_max:     value_by_name(item, 'Reload').try(:maximum_value),
          inventory_size:       value_by_name(item, 'Inventory Size').try(:value),
          inventory_size_min:   value_by_name(item, 'Inventory Size').try(:minimum_value),
          inventory_size_max:   value_by_name(item, 'Inventory Size').try(:maximum_value),
          equip_speed:          value_by_name(item, 'Equip Speed').try(:value),
          equip_speed_min:      value_by_name(item, 'Equip Speed').try(:minimum_value),
          equip_speed_max:      value_by_name(item, 'Equip Speed').try(:maximum_value),
          aim_assistance:       value_by_name(item, 'Aim assistance').try(:value),
          aim_assistance_min:   value_by_name(item, 'Aim assistance').try(:minimum_value),
          aim_assistance_max:   value_by_name(item, 'Aim assistance').try(:maximum_value),
          recoil_direction:     value_by_name(item, 'Recoil direction').try(:value),
          recoil_direction_min: value_by_name(item, 'Recoil direction').try(:minimum_value),
          recoil_direction_max: value_by_name(item, 'Recoil direction').try(:maximum_value),
        }

        weapon.update! params

        progressbar.increment
      end
    end

    def download_images
      asset_dir = Rails.root.join 'app', 'assets', 'images', 'weapons'
      progressbar = progress_bar Weapon.count, 'Downloading images'

      Weapon.find_each do |weapon|
        url  = "https://www.bungie.net#{weapon.icon}"
        file = "#{asset_dir}/#{File.basename(weapon.icon)}"

        progressbar.increment

        next if File.exist?(file)

        # write file
        open(file, 'wb') { |f| f << open(url).read }
      end
    end

    def progress_bar(total, title)
      ProgressBar.create(
        format: '%t: [%B] (%j%% %e)',
        length: 80,
        throttle_rate: 1,
        title: title,
        total: total,
      )
    end
end
