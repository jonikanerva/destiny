module WeaponsHelper
  def weapon_type_options(selected)
    options = Item.pluck(:item_type_name, :item_type).uniq.sort

    options_for_select options, selected
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
    count = Item.count
    max   = Item.maximum(:updated_at).try(:utc).try(:to_s, :number)

    "weapons/all-#{count}-#{max}"
  end

  def stat_description(stat)
    stat = Stat.find_by(name: stat)

    "#{stat.name} - #{stat.description}" if stat
  end

  def weapon_image(weapon)
    image_tag "https://bungie.net/#{weapon.icon}"
  end

  def stat_row(stat, options = {})
    data = {
      default: stat.value,
      min: stat.minimum_value,
      max: stat.maximum_value,
    }

    default_options = {
      class: :stat,
      data: data,
    }.merge options

    content_tag :td, stat.value, default_options
  end
end
