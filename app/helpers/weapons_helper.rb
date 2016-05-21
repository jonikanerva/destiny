module WeaponsHelper
  def weapon_type_options(selected)
    options = {
      'Primary' => [
        ['Auto Rifle',  :auto_rifles ],
        ['Hand Cannon', :hand_cannons],
        ['Pulse Rifle', :pulse_rifles],
        ['Scout Rifle', :scout_rifles],
      ],

      'Secondary' => [
        ['Fusion Rifle', :fusion_rifles],
        ['Shotgun',      :shotguns     ],
        ['Sidearm',      :sidearms     ],
        ['Sniper Rifle', :sniper_rifles],
      ],

      'Heavy' => [
        ['Machine Gun',     :machine_guns    ],
        ['Rocket Launcher', :rocket_launchers],
      ],
    }

    grouped_options_for_select options, selected
  end

  def armory_link(weapon)
    link = "https://www.bungie.net/en/Armory/Detail?item=#{weapon.item_hash}"

    link_to weapon.name, link, class: 'armory-link', title: weapon.description
  end

  def cache_key_for_weapons
    count = Weapon.count
    max   = Weapon.maximum(:updated_at).try(:utc).try(:to_s, :number)

    "weapons/all-#{count}-#{max}"
  end

  def stat_description(stat)
    stat = Stat.find_by(name: stat)

    "#{stat.name} - #{stat.description}" if stat
  end

  def weapon_image(weapon)
    image_path "weapons/#{File.basename(weapon.icon)}"
  end
end
