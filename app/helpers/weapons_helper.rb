module WeaponsHelper
  def weapon_type_options(selected)
    options = {
      'Primary' => [
        [ "Auto Rifle",  :auto_rifle  ],
        [ "Hand Cannon", :hand_cannon ],
        [ "Pulse Rifle", :pulse_rifle ],
        [ "Scout Rifle", :scout_rifle ],
      ],

      'Secondary' => [
        ["Fusion Rifle", :fusion_rifle ],
        ["Shotgun",      :shotgun      ],
        ["Sidearm",      :sidearm      ],
        ["Sniper Rifle", :sniper_rifle ],
      ],

      'Heavy' => [
        [ "Machine Gun",     :machine_gun     ],
        [ "Rocket Launcher", :rocket_launcher ],
      ],
    }

    grouped_options_for_select options, selected
  end

  def armory_link(name, item_id)
    link = "https://www.bungie.net/en/Armory/Detail?item=#{item_id}"

    link_to name, link, class: 'armory-link'
  end

  def sort_link(column_name)
    name = column_name.downcase

    params = {
      order: sort_order(name),
      sort: name,
    }

    link_to column_name, params, class: 'sort-link'
  end

  def sort_order(column_name)
    if params[:order] == 'desc' && params[:sort] == column_name
      :asc
    else
      :desc
    end
  end
end
