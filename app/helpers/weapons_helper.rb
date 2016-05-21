module WeaponsHelper
  def weapon_type_options(selected)
    options = {
      'Primary' => [
        ['Auto Rifle',  :auto_rifle ],
        ['Hand Cannon', :hand_cannon],
        ['Pulse Rifle', :pulse_rifle],
        ['Scout Rifle', :scout_rifle],
      ],

      'Secondary' => [
        ['Fusion Rifle', :fusion_rifle],
        ['Shotgun',      :shotgun     ],
        ['Sidearm',      :sidearm     ],
        ['Sniper Rifle', :sniper_rifle],
      ],

      'Heavy' => [
        ['Machine Gun',     :machine_gun    ],
        ['Rocket Launcher', :rocket_launcher],
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

    "#{stat.name} - #{stat.description}"
  end

  def weapon_image(weapon)
    image_path "weapons/#{File.basename(weapon.icon)}"
  end
end
