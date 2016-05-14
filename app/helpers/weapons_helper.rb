module WeaponsHelper
  def armory_link(name, item_id)
    link = "https://www.bungie.net/en/Armory/Detail?item=#{item_id}"

    link_to name, link, class: 'armory-link'
  end

  def sort_link(column_name)
    link_to column_name, { sort: column_name.downcase }, class: 'sort-link'
  end
end
