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

  def cache_key_for_weapons
    count = Item.count
    max   = Item.maximum(:updated_at).try(:utc).try(:to_s, :number)

    "weapons/all-#{count}-#{max}"
  end

  def stat_description(stat)
    return "N/A - This stat has not been named in Bungie.net data" unless stat.name

    "#{stat.name} - #{stat.description}"
  end

  def weapon_image(weapon)
    "https://bungie.net/#{weapon.icon}"
  end

  def stat_row(stat, options = {})
    data = {
      default: stat.value || 0,
      min: stat.minimum_value || 0,
      max: stat.maximum_value|| 0,
    }

    default_options = {
      class: :stat,
      data: data,
    }.merge options

    content_tag :td, stat.value || 0, default_options
  end
end
