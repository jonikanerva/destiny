module WeaponsHelper
  def armory_link(name, item_id)
    link = "https://www.bungie.net/en/Armory/Detail?item=#{item_id}"

    link_to name, link
  end
end
