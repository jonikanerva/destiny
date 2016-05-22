module WeaponsHelper
  def weapon_type_options(selected)
    options = {
      'Primary' => [
        ['Auto Rifles',  :auto_rifles ],
        ['Hand Cannons', :hand_cannons],
        ['Pulse Rifles', :pulse_rifles],
        ['Scout Rifles', :scout_rifles],
      ],

      'Secondary' => [
        ['Fusion Rifles', :fusion_rifles],
        ['Shotguns',      :shotguns     ],
        ['Sidearms',      :sidearms     ],
        ['Sniper Rifles', :sniper_rifles],
      ],

      'Heavy' => [
        ['Machine Gun',     :machine_guns    ],
        ['Rocket Launcher', :rocket_launchers],
      ],
    }

    grouped_options_for_select options, selected
  end

  def weapon_value_options
    options = [
      ['default values', :default],
      ['maximum values', :max    ],
      ['minimum values', :min    ],
    ]

    options_for_select options
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

  def stat_row(weapon, stat)
    data = {
      default: weapon.send(stat),
      min: weapon.send("#{stat}_min"),
      max: weapon.send("#{stat}_max"),
    }

    content_tag :td, weapon.send(stat), class: :stat, data: data
  end
end
