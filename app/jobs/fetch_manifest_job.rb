class FetchManifestJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    db_file = "/Users/joni/Desktop/world_sql_content_05feb511d99733ad8d1bbe60465007c1.content"

    SQLite3::Database.new(db_file) do |db|
      db.execute("select * from DestinyStatDefinition") do |row|
        json = JSON.parse row.second

        stat = Stat.find_or_initialize_by(stat_hash: json["statHash"])
        stat.stat_hash = json["statHash"]
        stat.name = json["statName"]
        stat.description = json["statDescription"]
        stat.save!
      end

      db.execute("select * from DestinyInventoryItemDefinition") do |row|
        json = JSON.parse row.second

        item = Item.find_or_initialize_by(item_hash: json["itemHash"])
        item.item_hash      = json["itemHash"]
        item.name           = json["itemName"]
        item.description    = json["itemDescription"]
        item.icon           = json["icon"]
        item.tier_type      = json["tierType"]
        item.tier_type_name = json["tierTypeName"]
        item.item_type_name = json["itemTypeName"]
        item.save!
      end
    end
  end
end
