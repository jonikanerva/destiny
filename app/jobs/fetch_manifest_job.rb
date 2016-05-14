class FetchManifestJob < ActiveJob::Base
  queue_as :default

  def perform(database_file)
    @database_file = database_file

    raise "Invalid database" unless File.exist?(@database_file)

    update_stats
    update_items_and_values
  end

  private

    def db
      @db ||= SQLite3::Database.new(@database_file)
    end

    def update_stats
      puts "Updating stats"

      db.execute("select * from DestinyStatDefinition") do |row|
        json = JSON.parse row.second

        stat = Stat.find_or_initialize_by stat_hash: json["statHash"]
        stat.stat_hash   = json["statHash"]
        stat.name        = json["statName"]
        stat.description = json["statDescription"]
        stat.save!
      end
    end

    def update_items_and_values
      puts "Updating items"

      db.execute("select * from DestinyInventoryItemDefinition") do |row|

        json = JSON.parse row.second

        item = Item.find_or_initialize_by item_hash: json["itemHash"]
        item.item_hash      = json["itemHash"]
        item.name           = json["itemName"]
        item.description    = json["itemDescription"]
        item.icon           = json["icon"]
        item.tier_type      = json["tierType"]
        item.tier_type_name = json["tierTypeName"]
        item.item_type_name = json["itemTypeName"]
        item.save!

        # loop item stat values
        json["stats"].each do |v|
          hash = v.last

          # try to find the stat, so we can add name/desc to this table as well
          stat = Stat.find_by stat_hash: hash["statHash"]

          puts "Stattia '#{hash["statHash"]}' ei löytynyt" if stat.nil?

          value = item.values.find_or_initialize_by stat_hash: hash["statHash"]
          value.stat_hash        = hash["statHash"]
          value.stat_name        = stat.try(:name)
          value.stat_description = stat.try(:description)
          value.value            = hash["value"]
          value.minimum_value    = hash["minimum"]
          value.maximum_value    = hash["maximum"]
          value.save!
        end
      end
    end
end
